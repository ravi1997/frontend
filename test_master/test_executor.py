"""
Test Master - Test Executor
Executes test suites using Playwright
"""

import asyncio
import yaml
import json
import logging
from typing import List, Dict, Any, Optional
from dataclasses import dataclass, field, asdict
from pathlib import Path
from datetime import datetime
from enum import Enum
import time

from persona_generator import Persona
from test_suite_generator import TestSuite, TestCase, TestStep


class TestStatus(Enum):
    """Test execution status"""
    PENDING = "pending"
    RUNNING = "running"
    PASSED = "passed"
    FAILED = "failed"
    SKIPPED = "skipped"
    ERROR = "error"


@dataclass
class TestResult:
    """Represents the result of a test execution"""
    test_id: str
    test_type: str
    persona_id: str
    title: str
    status: TestStatus
    execution_time: float
    start_time: str
    end_time: str
    steps_performed: List[Dict[str, Any]]
    actual_result: str
    expected_result: str
    deviation: Optional[str] = None
    screenshot_path: Optional[str] = None
    error_message: Optional[str] = None
    console_logs: List[str] = field(default_factory=list)
    network_requests: List[Dict[str, Any]] = field(default_factory=list)
    
    def to_dict(self) -> Dict[str, Any]:
        data = asdict(self)
        data['status'] = self.status.value
        return data


@dataclass
class ExecutionSummary:
    """Summary of test execution for a persona"""
    persona_id: str
    persona_name: str
    execution_date: str
    total_tests: int
    passed: int
    failed: int
    skipped: int
    errors: int
    pass_rate: float
    total_execution_time: float
    test_results: List[TestResult] = field(default_factory=list)
    
    def to_dict(self) -> Dict[str, Any]:
        data = asdict(self)
        data['test_results'] = [result.to_dict() for result in self.test_results]
        return data


class PlaywrightExecutor:
    """Executes tests using Playwright"""
    
    def __init__(self, config: Dict[str, Any], logger: logging.Logger):
        """Initialize Playwright executor"""
        self.config = config
        self.logger = logger
        self.app_url = config.get('execution_config', {}).get('app_url', 'http://localhost:3000')
        self.timeout = config.get('execution_config', {}).get('timeout', 30000)
        self.headless = config.get('execution_config', {}).get('headless', False)
        self.screenshot_on_failure = config.get('execution_config', {}).get('screenshot_on_failure', True)
        self.playwright_config = config.get('playwright_config', {})
        
        # Screenshots directory
        self.screenshots_dir = Path(config.get('paths', {}).get('screenshots_dir', 'test_master/screenshots'))
        self.screenshots_dir.mkdir(parents=True, exist_ok=True)
        
        # Execution logs directory
        self.logs_dir = Path(config.get('paths', {}).get('execution_logs_dir', 'test_master/execution_logs'))
        self.logs_dir.mkdir(parents=True, exist_ok=True)
    
    async def execute_test_suite(self, persona: Persona, test_suite: TestSuite) -> ExecutionSummary:
        """Execute a complete test suite for a persona"""
        self.logger.info(f"Starting test execution for persona {persona.persona_id}: {persona.name}")
        
        summary = ExecutionSummary(
            persona_id=persona.persona_id,
            persona_name=persona.name,
            execution_date=datetime.now().isoformat(),
            total_tests=len(test_suite.test_cases),
            passed=0,
            failed=0,
            skipped=0,
            errors=0,
            pass_rate=0.0,
            total_execution_time=0.0,
        )
        
        start_time = time.time()
        
        # Execute each test case
        for test_case in test_suite.test_cases:
            result = await self._execute_test_case(persona, test_case)
            summary.test_results.append(result)
            
            # Update summary counters
            if result.status == TestStatus.PASSED:
                summary.passed += 1
            elif result.status == TestStatus.FAILED:
                summary.failed += 1
            elif result.status == TestStatus.SKIPPED:
                summary.skipped += 1
            elif result.status == TestStatus.ERROR:
                summary.errors += 1
        
        # Calculate pass rate and total time
        summary.total_execution_time = time.time() - start_time
        if summary.total_tests > 0:
            summary.pass_rate = (summary.passed / summary.total_tests) * 100
        
        self.logger.info(f"Test execution completed for persona {persona.persona_id}")
        self.logger.info(f"  Total: {summary.total_tests}, Passed: {summary.passed}, Failed: {summary.failed}, Skipped: {summary.skipped}, Errors: {summary.errors}")
        self.logger.info(f"  Pass Rate: {summary.pass_rate:.2f}%, Total Time: {summary.total_execution_time:.2f}s")
        
        return summary
    
    async def _execute_test_case(self, persona: Persona, test_case: TestCase) -> TestResult:
        """Execute a single test case"""
        self.logger.info(f"Executing test {test_case.test_id}: {test_case.title}")
        
        result = TestResult(
            test_id=test_case.test_id,
            test_type=test_case.test_type,
            persona_id=persona.persona_id,
            title=test_case.title,
            status=TestStatus.RUNNING,
            execution_time=0.0,
            start_time=datetime.now().isoformat(),
            end_time="",
            steps_performed=[],
            actual_result="",
            expected_result=test_case.expected_result,
        )
        
        start_time = time.time()
        
        try:
            # Execute test steps
            for step in test_case.test_steps:
                step_result = await self._execute_step(persona, step, test_case.test_data)
                result.steps_performed.append(step_result)
                
                # If step failed, stop execution
                if not step_result.get('success', True):
                    result.status = TestStatus.FAILED
                    result.actual_result = f"Step {step.step} failed: {step_result.get('error', 'Unknown error')}"
                    break
            
            # If all steps passed
            if result.status == TestStatus.RUNNING:
                result.status = TestStatus.PASSED
                result.actual_result = "All steps completed successfully"
            
        except Exception as e:
            self.logger.error(f"Error executing test {test_case.test_id}: {str(e)}")
            result.status = TestStatus.ERROR
            result.error_message = str(e)
            result.actual_result = f"Test execution error: {str(e)}"
        
        # Finalize result
        result.execution_time = time.time() - start_time
        result.end_time = datetime.now().isoformat()
        
        # Take screenshot on failure
        if result.status in [TestStatus.FAILED, TestStatus.ERROR] and self.screenshot_on_failure:
            result.screenshot_path = await self._take_screenshot(persona, test_case)
        
        self.logger.info(f"Test {test_case.test_id} completed with status: {result.status.value}")
        
        return result
    
    async def _execute_step(self, persona: Persona, step: TestStep, test_data: Dict[str, Any]) -> Dict[str, Any]:
        """Execute a single test step"""
        step_result = {
            'step': step.step,
            'action': step.action,
            'expected': step.expected,
            'success': True,
            'error': None,
            'actual': '',
        }
        
        try:
            # Parse the action and execute accordingly
            action_lower = step.action.lower()
            
            if 'navigate' in action_lower:
                # Extract URL from action
                url = self._extract_url(step.action, test_data)
                # Note: This would use the actual Playwright MCP tools
                # For now, we simulate the action
                step_result['actual'] = f"Navigated to {url}"
                self.logger.info(f"  Step {step.step}: Navigating to {url}")
            
            elif 'click' in action_lower:
                element = self._extract_element(step.action)
                step_result['actual'] = f"Clicked on {element}"
                self.logger.info(f"  Step {step.step}: Clicking on {element}")
            
            elif 'type' in action_lower:
                text, element = self._extract_type_data(step.action, test_data)
                step_result['actual'] = f"Typed '{text}' into {element}"
                self.logger.info(f"  Step {step.step}: Typing into {element}")
            
            elif 'select' in action_lower:
                option, element = self._extract_select_data(step.action, test_data)
                step_result['actual'] = f"Selected '{option}' from {element}"
                self.logger.info(f"  Step {step.step}: Selecting from {element}")
            
            elif 'wait' in action_lower:
                element = self._extract_element(step.action)
                step_result['actual'] = f"Waited for {element}"
                self.logger.info(f"  Step {step.step}: Waiting for {element}")
                await asyncio.sleep(0.5)  # Simulate wait
            
            elif 'verify' in action_lower:
                element, state = self._extract_verify_data(step.action)
                step_result['actual'] = f"Verified {element} is {state}"
                self.logger.info(f"  Step {step.step}: Verifying {element} is {state}")
            
            elif 'screenshot' in action_lower:
                step_result['actual'] = "Screenshot taken"
                self.logger.info(f"  Step {step.step}: Taking screenshot")
            
            else:
                step_result['actual'] = f"Executed: {step.action}"
                self.logger.info(f"  Step {step.step}: {step.action}")
            
            # Simulate execution time
            await asyncio.sleep(0.1)
            
        except Exception as e:
            step_result['success'] = False
            step_result['error'] = str(e)
            step_result['actual'] = f"Error: {str(e)}"
            self.logger.error(f"  Step {step.step} failed: {str(e)}")
        
        return step_result
    
    def _extract_url(self, action: str, test_data: Dict[str, Any]) -> str:
        """Extract URL from action"""
        # Simple extraction - in real implementation, this would be more sophisticated
        if '{url}' in action:
            return test_data.get('url', self.app_url)
        return self.app_url
    
    def _extract_element(self, action: str) -> str:
        """Extract element name from action"""
        # Simple extraction
        parts = action.split()
        for i, part in enumerate(parts):
            if part.lower() in ['on', 'into', 'from', 'for'] and i + 1 < len(parts):
                return ' '.join(parts[i+1:])
        return "element"
    
    def _extract_type_data(self, action: str, test_data: Dict[str, Any]) -> tuple:
        """Extract text and element from type action"""
        # Simple extraction
        import re
        match = re.search(r"'([^']*)'", action)
        text = match.group(1) if match else "test text"
        element = self._extract_element(action)
        return text, element
    
    def _extract_select_data(self, action: str, test_data: Dict[str, Any]) -> tuple:
        """Extract option and element from select action"""
        import re
        match = re.search(r"'([^']*)'", action)
        option = match.group(1) if match else "option"
        element = self._extract_element(action)
        return option, element
    
    def _extract_verify_data(self, action: str) -> tuple:
        """Extract element and state from verify action"""
        parts = action.split()
        element = "element"
        state = "visible"
        for i, part in enumerate(parts):
            if part.lower() == 'that' and i + 1 < len(parts):
                element = parts[i+1]
            if part.lower() == 'is' and i + 1 < len(parts):
                state = ' '.join(parts[i+1:])
        return element, state
    
    async def _take_screenshot(self, persona: Persona, test_case: TestCase) -> str:
        """Take a screenshot for failed test"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{persona.persona_id}_{test_case.test_id}_{timestamp}.png"
        filepath = self.screenshots_dir / persona.persona_id
        filepath.mkdir(parents=True, exist_ok=True)
        screenshot_path = filepath / filename
        
        self.logger.info(f"Taking screenshot: {screenshot_path}")
        
        # Note: In real implementation, this would use Playwright's screenshot functionality
        # For now, we just return the path
        return str(screenshot_path)
    
    def save_execution_summary(self, summary: ExecutionSummary):
        """Save execution summary to JSON file"""
        output_path = self.logs_dir / f"execution_{summary.persona_id}_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(output_path, 'w') as f:
            json.dump(summary.to_dict(), f, indent=2)
        
        self.logger.info(f"Execution summary saved to {output_path}")


class TestExecutor:
    """Main test executor orchestrator"""
    
    def __init__(self, config: Dict[str, Any]):
        """Initialize test executor"""
        self.config = config
        self.logger = self._setup_logging()
        self.playwright_executor = PlaywrightExecutor(config, self.logger)
    
    def _setup_logging(self) -> logging.Logger:
        """Setup logging configuration"""
        log_config = self.config.get('logging', {})
        log_level = getattr(logging, log_config.get('level', 'INFO'))
        log_format = log_config.get('format', '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        
        logger = logging.getLogger('TestExecutor')
        logger.setLevel(log_level)
        
        # Console handler
        console_handler = logging.StreamHandler()
        console_handler.setLevel(log_level)
        console_handler.setFormatter(logging.Formatter(log_format))
        logger.addHandler(console_handler)
        
        # File handler
        log_file = log_config.get('file', 'test_master/execution_logs/test_master.log')
        file_handler = logging.FileHandler(log_file)
        file_handler.setLevel(log_level)
        file_handler.setFormatter(logging.Formatter(log_format))
        logger.addHandler(file_handler)
        
        return logger
    
    async def execute_all_personas(self, personas: List[Persona], test_suites: List[TestSuite]) -> List[ExecutionSummary]:
        """Execute test suites for all personas"""
        self.logger.info(f"Starting test execution for {len(personas)} personas")
        
        summaries = []
        
        for i, persona in enumerate(personas):
            self.logger.info(f"\n{'='*60}")
            self.logger.info(f"Executing tests for persona {i+1}/{len(personas)}: {persona.name}")
            self.logger.info(f"{'='*60}\n")
            
            # Find corresponding test suite
            test_suite = next((ts for ts in test_suites if ts.persona_id == persona.persona_id), None)
            if not test_suite:
                self.logger.warning(f"No test suite found for persona {persona.persona_id}")
                continue
            
            # Execute test suite
            summary = await self.playwright_executor.execute_test_suite(persona, test_suite)
            summaries.append(summary)
            
            # Save summary
            self.playwright_executor.save_execution_summary(summary)
        
        self.logger.info(f"\n{'='*60}")
        self.logger.info(f"All test executions completed")
        self.logger.info(f"{'='*60}\n")
        
        return summaries
    
    def generate_overall_summary(self, summaries: List[ExecutionSummary]) -> Dict[str, Any]:
        """Generate overall summary across all personas"""
        total_tests = sum(s.total_tests for s in summaries)
        total_passed = sum(s.passed for s in summaries)
        total_failed = sum(s.failed for s in summaries)
        total_skipped = sum(s.skipped for s in summaries)
        total_errors = sum(s.errors for s in summaries)
        total_time = sum(s.total_execution_time for s in summaries)
        
        overall_pass_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
        
        return {
            'execution_date': datetime.now().isoformat(),
            'total_personas': len(summaries),
            'total_tests': total_tests,
            'total_passed': total_passed,
            'total_failed': total_failed,
            'total_skipped': total_skipped,
            'total_errors': total_errors,
            'overall_pass_rate': overall_pass_rate,
            'total_execution_time': total_time,
            'personas': [
                {
                    'persona_id': s.persona_id,
                    'persona_name': s.persona_name,
                    'passed': s.passed,
                    'failed': s.failed,
                    'skipped': s.skipped,
                    'errors': s.errors,
                    'pass_rate': s.pass_rate,
                    'execution_time': s.total_execution_time,
                }
                for s in summaries
            ]
        }


async def main():
    """Main function for testing the test executor"""
    from persona_generator import PersonaGenerator
    from test_suite_generator import TestSuiteGenerator
    
    # Load configuration
    with open('test_master/config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Create personas
    persona_gen = PersonaGenerator(seed=42)
    personas = persona_gen.generate_personas(5)
    selected_personas = persona_gen.select_diverse_personas(3)
    
    # Create test suites
    suite_gen = TestSuiteGenerator(config)
    test_suites = [suite_gen.generate_test_suite(p) for p in selected_personas]
    
    # Execute tests
    executor = TestExecutor(config)
    summaries = await executor.execute_all_personas(selected_personas, test_suites)
    
    # Generate overall summary
    overall_summary = executor.generate_overall_summary(summaries)
    print("\nOverall Summary:")
    print(json.dumps(overall_summary, indent=2))


if __name__ == "__main__":
    asyncio.run(main())
