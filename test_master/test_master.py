"""
Test Master - Main Orchestrator
Comprehensive Automated Testing Orchestration System
"""

import asyncio
import yaml
import logging
import argparse
from typing import List, Dict, Any, Optional
from pathlib import Path
from datetime import datetime

from persona_generator import PersonaGenerator, Persona
from test_suite_generator import TestSuiteGenerator, TestSuite
from test_executor import TestExecutor, ExecutionSummary
from report_generator import ReportGenerator
from agent_os_integration import AgentOSIntegration


class TestMaster:
    """Main Test Master orchestrator"""
    
    def __init__(self, config_path: str = 'test_master/config.yaml'):
        """Initialize Test Master"""
        self.config = self._load_config(config_path)
        self.logger = self._setup_logging()
        
        # Initialize components
        self.persona_generator = PersonaGenerator(
            seed=self.config.get('persona_generation', {}).get('random_seed')
        )
        self.test_suite_generator = TestSuiteGenerator(self.config)
        self.test_executor = TestExecutor(self.config)
        self.report_generator = ReportGenerator(self.config, self.logger)
        self.agent_os_integration = AgentOSIntegration(self.config, self.logger)
        
        self.logger.info("Test Master initialized successfully")
        self.logger.info(f"Configuration loaded from {config_path}")
    
    def _load_config(self, config_path: str) -> Dict[str, Any]:
        """Load configuration from YAML file"""
        config_file = Path(config_path)
        if not config_file.exists():
            # Create default config
            return self._create_default_config(config_path)
        
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
        
        # Add base directory to config
        config['base_dir'] = str(Path(config_path).parent.parent)
        
        return config
    
    def _create_default_config(self, config_path: str) -> Dict[str, Any]:
        """Create default configuration"""
        default_config = {
            'execution_config': {
                'app_url': 'http://localhost:3000',
                'timeout': 30000,
                'headless': False,
                'screenshot_on_failure': True,
            },
            'persona_generation': {
                'total_personas': 25,
                'selected_personas': 5,
                'ensure_diversity': True,
                'include_accessibility': True,
                'include_security_focused': True,
                'random_seed': None,
            },
            'test_types': [
                'unit_tests', 'integration_tests', 'system_tests',
                'regression_tests', 'ui_tests', 'impression_tests',
                'usability_tests', 'exploratory_tests',
                'performance_tests', 'security_tests', 'accessibility_tests',
                'expected_failure_cases',
            ],
            'quality_gates': {
                'logic_correctness': 100,
                'static_analysis': 0,
                'build_integrity': 'no_warnings',
                'code_hygiene': 'no_new_todos',
                'coverage': 80,
            },
            'output_format': {
                'persona_reports': 'markdown',
                'manager_report': 'markdown',
                'include_screenshots': True,
                'include_execution_logs': True,
                'include_performance_metrics': True,
            },
            'agent_os_integration': {
                'enabled': True,
                'state_files': {
                    'project_state': 'agent/09_state/PROJECT_STATE.md',
                    'test_state': 'agent/09_state/TEST_STATE.md',
                    'backlog_state': 'agent/09_state/BACKLOG_STATE.md',
                },
                'gates': {
                    'global_quality': 'agent/05_gates/global/gate_global_quality.md',
                    'testing_rules': 'agent/11_rules/testing_rules.md',
                },
            },
            'paths': {
                'personas_dir': 'test_master/personas',
                'test_suites_dir': 'test_master/test_suites',
                'execution_logs_dir': 'test_master/execution_logs',
                'screenshots_dir': 'test_master/screenshots',
                'reports_dir': 'test_master/reports',
                'artifacts_dir': 'test_master/artifacts',
                'continuity_dir': 'test_master/continuity',
                'plans_dir': 'plans',
            },
            'playwright_config': {
                'browser': 'chromium',
                'viewport': {'width': 1280, 'height': 720},
                'slow_mo': 0,
                'trace': 'retain-on-failure',
                'video': 'retain-on-failure',
            },
            'logging': {
                'level': 'INFO',
                'format': '%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                'file': 'test_master/execution_logs/test_master.log',
            },
            'continuity': {
                'enabled': True,
                'auto_save_interval': 60,
                'snapshot_dir': 'test_master/continuity',
            },
            'features': [],
        }
        
        # Save default config
        config_file = Path(config_path)
        config_file.parent.mkdir(parents=True, exist_ok=True)
        with open(config_path, 'w') as f:
            yaml.dump(default_config, f, default_flow_style=False, sort_keys=False)
        
        print(f"Created default configuration at {config_path}")
        
        return default_config
    
    def _setup_logging(self) -> logging.Logger:
        """Setup logging configuration"""
        log_config = self.config.get('logging', {})
        log_level = getattr(logging, log_config.get('level', 'INFO'))
        log_format = log_config.get('format', '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
        
        logger = logging.getLogger('TestMaster')
        logger.setLevel(log_level)
        
        # Clear existing handlers
        logger.handlers.clear()
        
        # Console handler
        console_handler = logging.StreamHandler()
        console_handler.setLevel(log_level)
        console_handler.setFormatter(logging.Formatter(log_format))
        logger.addHandler(console_handler)
        
        # File handler
        log_file = log_config.get('file', 'test_master/execution_logs/test_master.log')
        log_path = Path(log_file)
        log_path.parent.mkdir(parents=True, exist_ok=True)
        
        file_handler = logging.FileHandler(log_file)
        file_handler.setLevel(log_level)
        file_handler.setFormatter(logging.Formatter(log_format))
        logger.addHandler(file_handler)
        
        return logger
    
    async def run_full_cycle(self) -> Dict[str, Any]:
        """Run complete test cycle from start to finish"""
        self.logger.info("="*60)
        self.logger.info("Starting Full Test Master Cycle")
        self.logger.info("="*60)
        
        start_time = datetime.now()
        
        try:
            # Phase 1: Context Initialization
            self.logger.info("\n[Phase 1/7] Context Initialization")
            await self._phase1_context_initialization()
            
            # Phase 2: Persona Generation
            self.logger.info("\n[Phase 2/7] Persona Generation")
            personas = await self._phase2_persona_generation()
            
            # Phase 3: Test Suite Generation
            self.logger.info("\n[Phase 3/7] Test Suite Generation")
            test_suites = await self._phase3_test_suite_generation(personas)
            
            # Phase 4: Test Execution
            self.logger.info("\n[Phase 4/7] Test Execution")
            summaries = await self._phase4_test_execution(personas, test_suites)
            
            # Phase 5: Report Generation
            self.logger.info("\n[Phase 5/7] Report Generation")
            report_paths = await self._phase5_report_generation(personas, test_suites, summaries)
            
            # Phase 6: Agent OS State Update
            self.logger.info("\n[Phase 6/7] Agent OS State Update")
            await self._phase6_agent_os_update(summaries)
            
            # Phase 7: Final Summary
            self.logger.info("\n[Phase 7/7] Final Summary")
            final_summary = await self._phase7_final_summary(personas, summaries, report_paths, start_time)
            
            return final_summary
            
        except Exception as e:
            self.logger.error(f"Error during test cycle: {str(e)}", exc_info=True)
            raise
    
    async def _phase1_context_initialization(self):
        """Phase 1: Initialize context and load Agent OS state"""
        self.logger.info("Loading Agent OS state...")
        
        # Load Agent OS state
        self.agent_os_integration.load_state()
        
        # Get integration progress
        integration_progress = self.agent_os_integration.get_integration_progress()
        if integration_progress:
            self.logger.info(f"Found {len(integration_progress)} milestones in integration progress")
        
        # Get dependencies
        dependencies = self.agent_os_integration.get_dependencies()
        if dependencies:
            self.logger.info(f"Found dependencies: {len(dependencies.get('flutter', []))} Flutter, {len(dependencies.get('python', []))} Python")
        
        # Get test scenarios
        test_scenarios = self.agent_os_integration.get_test_scenarios()
        if test_scenarios:
            self.logger.info(f"Found {len(test_scenarios)} test scenarios in plans folder")
        
        self.logger.info("Context initialization completed")
    
    async def _phase2_persona_generation(self) -> List[Persona]:
        """Phase 2: Generate personas"""
        total_personas = self.config.get('persona_generation', {}).get('total_personas', 25)
        selected_count = self.config.get('persona_generation', {}).get('selected_personas', 5)
        
        self.logger.info(f"Generating {total_personas} diverse personas...")
        
        # Generate all personas
        personas = self.persona_generator.generate_personas(total_personas)
        self.logger.info(f"Generated {len(personas)} personas")
        
        # Save all personas
        personas_dir = self.config.get('paths', {}).get('personas_dir', 'test_master/personas')
        self.persona_generator.save_personas(personas_dir)
        self.logger.info(f"Saved personas to {personas_dir}")
        
        # Select diverse personas
        self.logger.info(f"Selecting {selected_count} diverse personas...")
        selected_personas = self.persona_generator.select_diverse_personas(selected_count)
        self.logger.info(f"Selected {len(selected_personas)} personas:")
        
        for persona in selected_personas:
            self.logger.info(f"  - {persona.persona_id}: {persona.name} ({persona.technology_experience}, {persona.behavior}, {persona.testing_style})")
        
        return selected_personas
    
    async def _phase3_test_suite_generation(self, personas: List[Persona]) -> List[TestSuite]:
        """Phase 3: Generate test suites for personas"""
        self.logger.info("Generating test suites for selected personas...")
        
        test_suites = []
        test_suites_dir = self.config.get('paths', {}).get('test_suites_dir', 'test_master/test_suites')
        
        for persona in personas:
            self.logger.info(f"Generating test suite for {persona.persona_id}: {persona.name}")
            
            # Generate test suite
            test_suite = self.test_suite_generator.generate_test_suite(persona)
            test_suites.append(test_suite)
            
            self.logger.info(f"  Generated {len(test_suite.test_cases)} test cases")
            
            # Save test suite
            self.test_suite_generator.save_test_suite(test_suite, test_suites_dir)
        
        self.logger.info(f"Generated {len(test_suites)} test suites")
        
        return test_suites
    
    async def _phase4_test_execution(self, personas: List[Persona], 
                                    test_suites: List[TestSuite]) -> List[ExecutionSummary]:
        """Phase 4: Execute test suites"""
        self.logger.info("Executing test suites...")
        
        # Execute all test suites
        summaries = await self.test_executor.execute_all_personas(personas, test_suites)
        
        self.logger.info("Test execution completed")
        
        return summaries
    
    async def _phase5_report_generation(self, personas: List[Persona], test_suites: List[TestSuite],
                                      summaries: List[ExecutionSummary]) -> Dict[str, Any]:
        """Phase 5: Generate reports"""
        self.logger.info("Generating reports...")
        
        report_paths = {
            'persona_reports': [],
            'manager_report': None,
        }
        
        # Generate persona reports
        for persona, test_suite, summary in zip(personas, test_suites, summaries):
            self.logger.info(f"Generating persona report for {persona.persona_id}")
            report_path = self.report_generator.generate_persona_report(persona, test_suite, summary)
            report_paths['persona_reports'].append(report_path)
        
        # Generate manager report
        self.logger.info("Generating manager-level comprehensive report")
        manager_report_path = self.report_generator.generate_manager_report(personas, summaries, self.config)
        report_paths['manager_report'] = manager_report_path
        
        self.logger.info("Report generation completed")
        
        return report_paths
    
    async def _phase6_agent_os_update(self, summaries: List[ExecutionSummary]):
        """Phase 6: Update Agent OS state"""
        self.logger.info("Updating Agent OS state...")
        
        # Update test state
        self.agent_os_integration.update_test_state(summaries)
        
        # Update project state
        self.agent_os_integration.update_project_state(summaries)
        
        # Validate quality gates
        validation_result = self.agent_os_integration.validate_quality_gates(summaries)
        self.logger.info(f"Quality gate validation: {validation_result['status']}")
        
        # Save state
        self.agent_os_integration.save_state()
        
        # Generate continuity snapshot
        if self.config.get('continuity', {}).get('enabled', True):
            self.agent_os_integration.generate_continuity_snapshot(summaries)
        
        self.logger.info("Agent OS state updated successfully")
    
    async def _phase7_final_summary(self, personas: List[Persona], summaries: List[ExecutionSummary],
                                    report_paths: Dict[str, Any], start_time: datetime) -> Dict[str, Any]:
        """Phase 7: Generate final summary"""
        self.logger.info("Generating final summary...")
        
        end_time = datetime.now()
        duration = (end_time - start_time).total_seconds()
        
        # Calculate overall statistics
        total_tests = sum(s.total_tests for s in summaries)
        total_passed = sum(s.passed for s in summaries)
        total_failed = sum(s.failed for s in summaries)
        overall_pass_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
        
        # Generate final summary
        final_summary = {
            'execution_date': end_time.isoformat(),
            'duration_seconds': duration,
            'duration_formatted': f"{duration:.2f}s",
            'total_personas': len(personas),
            'total_tests': total_tests,
            'total_passed': total_passed,
            'total_failed': total_failed,
            'overall_pass_rate': overall_pass_rate,
            'report_paths': report_paths,
        }
        
        # Print summary
        self.logger.info("\n" + "="*60)
        self.logger.info("FINAL SUMMARY")
        self.logger.info("="*60)
        self.logger.info(f"Execution Date: {end_time.strftime('%Y-%m-%d %H:%M:%S UTC')}")
        self.logger.info(f"Duration: {duration:.2f}s")
        self.logger.info(f"Total Personas: {len(personas)}")
        self.logger.info(f"Total Tests: {total_tests}")
        self.logger.info(f"Passed: {total_passed}")
        self.logger.info(f"Failed: {total_failed}")
        self.logger.info(f"Pass Rate: {overall_pass_rate:.2f}%")
        self.logger.info(f"\nReports:")
        self.logger.info(f"  Manager Report: {report_paths['manager_report']}")
        for i, path in enumerate(report_paths['persona_reports'], 1):
            self.logger.info(f"  Persona Report {i}: {path}")
        self.logger.info("="*60)
        
        return final_summary
    
    async def run_personas_only(self, persona_ids: List[str] = None):
        """Run tests for specific personas only"""
        self.logger.info("Running personas-only mode...")
        
        # Load existing personas
        personas_dir = self.config.get('paths', {}).get('personas_dir', 'test_master/personas')
        personas = self.persona_generator.load_personas(personas_dir)
        
        # Filter by persona IDs if specified
        if persona_ids:
            personas = [p for p in personas if p.persona_id in persona_ids]
            self.logger.info(f"Running tests for {len(personas)} specific personas")
        
        # Generate test suites
        test_suites = [self.test_suite_generator.generate_test_suite(p) for p in personas]
        
        # Execute tests
        summaries = await self.test_executor.execute_all_personas(personas, test_suites)
        
        # Generate reports
        for persona, test_suite, summary in zip(personas, test_suites, summaries):
            self.report_generator.generate_persona_report(persona, test_suite, summary)
        
        self.logger.info("Personas-only execution completed")
    
    async def run_reports_only(self):
        """Generate reports only (assumes test execution already done)"""
        self.logger.info("Running reports-only mode...")
        
        # Load existing personas
        personas_dir = self.config.get('paths', {}).get('personas_dir', 'test_master/personas')
        personas = self.persona_generator.load_personas(personas_dir)
        
        # Load existing test suites
        test_suites_dir = self.config.get('paths', {}).get('test_suites_dir', 'test_master/test_suites')
        # This would need to be implemented to load test suites
        
        self.logger.info("Reports-only mode completed")


def main():
    """Main entry point"""
    parser = argparse.ArgumentParser(description='Test Master - Comprehensive Automated Testing Orchestration System')
    parser.add_argument('--config', '-c', default='test_master/config.yaml',
                        help='Path to configuration file')
    parser.add_argument('--mode', '-m', choices=['full', 'personas', 'reports'],
                        default='full', help='Execution mode')
    parser.add_argument('--personas', '-p', nargs='+', help='Specific persona IDs to run')
    parser.add_argument('--verbose', '-v', action='store_true', help='Enable verbose logging')
    
    args = parser.parse_args()
    
    # Create Test Master instance
    test_master = TestMaster(args.config)
    
    # Set verbose logging if requested
    if args.verbose:
        test_master.logger.setLevel(logging.DEBUG)
        for handler in test_master.logger.handlers:
            handler.setLevel(logging.DEBUG)
    
    # Run in requested mode
    if args.mode == 'full':
        asyncio.run(test_master.run_full_cycle())
    elif args.mode == 'personas':
        asyncio.run(test_master.run_personas_only(args.personas))
    elif args.mode == 'reports':
        asyncio.run(test_master.run_reports_only())


if __name__ == "__main__":
    main()
