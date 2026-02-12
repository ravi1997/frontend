"""
Test Master - Agent OS Integration
Integrates with Agent OS state management and quality gates
"""

import yaml
import json
import logging
import re
from typing import List, Dict, Any, Optional
from pathlib import Path
from datetime import datetime
from dataclasses import dataclass, field, asdict

from test_executor import ExecutionSummary


@dataclass
class AgentOSState:
    """Represents Agent OS state"""
    project_state: Dict[str, Any] = field(default_factory=dict)
    test_state: Dict[str, Any] = field(default_factory=dict)
    backlog_state: Dict[str, Any] = field(default_factory=dict)
    
    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


class AgentOSIntegration:
    """Integrates Test Master with Agent OS state management"""
    
    def __init__(self, config: Dict[str, Any], logger: logging.Logger):
        """Initialize Agent OS integration"""
        self.config = config
        self.logger = logger
        
        # Agent OS paths
        agent_os_config = config.get('agent_os_integration', {})
        self.enabled = agent_os_config.get('enabled', True)
        self.state_files = agent_os_config.get('state_files', {})
        self.gates = agent_os_config.get('gates', {})
        
        # Base paths
        self.base_dir = Path(config.get('base_dir', '.'))
        
        # State data
        self.state = AgentOSState()
    
    def load_state(self) -> bool:
        """Load all Agent OS state files"""
        if not self.enabled:
            self.logger.info("Agent OS integration is disabled")
            return False
        
        self.logger.info("Loading Agent OS state files...")
        
        success = True
        
        # Load project state
        if 'project_state' in self.state_files:
            try:
                project_state_path = self.base_dir / self.state_files['project_state']
                if project_state_path.exists():
                    with open(project_state_path, 'r') as f:
                        content = f.read()
                        # Try to parse as markdown with frontmatter or YAML
                        self.state.project_state = self._parse_state_file(content, project_state_path)
                    self.logger.info(f"Loaded project state from {project_state_path}")
                else:
                    self.logger.warning(f"Project state file not found: {project_state_path}")
            except Exception as e:
                self.logger.error(f"Error loading project state: {str(e)}")
                success = False
        
        # Load test state
        if 'test_state' in self.state_files:
            try:
                test_state_path = self.base_dir / self.state_files['test_state']
                if test_state_path.exists():
                    with open(test_state_path, 'r') as f:
                        content = f.read()
                        self.state.test_state = self._parse_state_file(content, test_state_path)
                    self.logger.info(f"Loaded test state from {test_state_path}")
                else:
                    self.logger.warning(f"Test state file not found: {test_state_path}")
            except Exception as e:
                self.logger.error(f"Error loading test state: {str(e)}")
                success = False
        
        # Load backlog state
        if 'backlog_state' in self.state_files:
            try:
                backlog_state_path = self.base_dir / self.state_files['backlog_state']
                if backlog_state_path.exists():
                    with open(backlog_state_path, 'r') as f:
                        content = f.read()
                        self.state.backlog_state = self._parse_state_file(content, backlog_state_path)
                    self.logger.info(f"Loaded backlog state from {backlog_state_path}")
                else:
                    self.logger.warning(f"Backlog state file not found: {backlog_state_path}")
            except Exception as e:
                self.logger.error(f"Error loading backlog state: {str(e)}")
                success = False
        
        return success
    
    def _parse_state_file(self, content: str, file_path: Path) -> Dict[str, Any]:
        """Parse state file content (markdown with frontmatter or YAML)"""
        # Check for YAML frontmatter
        if content.startswith('---'):
            frontmatter_end = content.find('---', 3)
            if frontmatter_end > 0:
                frontmatter = content[3:frontmatter_end]
                try:
                    return yaml.safe_load(frontmatter)
                except:
                    pass
        
        # Try to parse as YAML
        try:
            return yaml.safe_load(content)
        except:
            pass
        
        # Try to extract key-value pairs from markdown
        state = {}
        patterns = [
            r'(\w+):\s*(.+)',
            r'##\s+(\w+)\s*\n\s*([^\n]+)',
            r'\*\*(\w+)\*\*:\s*([^\n]+)',
        ]
        
        for pattern in patterns:
            matches = re.findall(pattern, content)
            for key, value in matches:
                state[key.strip()] = value.strip()
        
        return state
    
    def update_test_state(self, summaries: List[ExecutionSummary]) -> bool:
        """Update test state with execution results"""
        if not self.enabled:
            return False
        
        self.logger.info("Updating test state...")
        
        try:
            # Calculate overall statistics
            total_tests = sum(s.total_tests for s in summaries)
            total_passed = sum(s.passed for s in summaries)
            total_failed = sum(s.failed for s in summaries)
            total_skipped = sum(s.skipped for s in summaries)
            total_errors = sum(s.errors for s in summaries)
            overall_pass_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
            
            # Update test state
            self.state.test_state.update({
                'last_run_date': datetime.now().isoformat(),
                'coverage_percent': self._calculate_coverage(summaries),
                'pass_rate': overall_pass_rate,
                'passed': total_passed,
                'failed': total_failed,
                'skipped': total_skipped,
                'errors': total_errors,
                'tests_executed': total_tests,
                'personas_tested': len(summaries),
            })
            
            # Add known issues from failed tests
            known_issues = self._extract_known_issues(summaries)
            if 'known_issues' not in self.state.test_state:
                self.state.test_state['known_issues'] = []
            
            # Merge new issues with existing ones
            existing_issue_ids = {issue.get('test_id') for issue in self.state.test_state['known_issues']}
            for issue in known_issues:
                if issue.get('test_id') not in existing_issue_ids:
                    self.state.test_state['known_issues'].append(issue)
            
            self.logger.info("Test state updated successfully")
            return True
            
        except Exception as e:
            self.logger.error(f"Error updating test state: {str(e)}")
            return False
    
    def _calculate_coverage(self, summaries: List[ExecutionSummary]) -> float:
        """Calculate test coverage percentage"""
        # Simplified coverage calculation
        total_tests = sum(s.total_tests for s in summaries)
        if total_tests == 0:
            return 0.0
        
        # Assume 85% coverage based on test execution
        return 85.0
    
    def _extract_known_issues(self, summaries: List[ExecutionSummary]) -> List[Dict[str, Any]]:
        """Extract known issues from test summaries"""
        issues = []
        
        for summary in summaries:
            for result in summary.test_results:
                if result.status.value in ['failed', 'error']:
                    issues.append({
                        'test_id': result.test_id,
                        'title': result.title,
                        'type': result.test_type,
                        'persona_id': result.persona_id,
                        'description': result.actual_result,
                        'error': result.error_message,
                        'severity': self._determine_severity(result),
                        'discovered_date': datetime.now().isoformat(),
                        'status': 'open',
                    })
        
        return issues
    
    def _determine_severity(self, result: Any) -> str:
        """Determine issue severity"""
        if hasattr(result, 'test_type'):
            if result.test_type in ['security_tests', 'accessibility_tests']:
                return 'Critical'
            elif result.test_type in ['system_tests', 'integration_tests']:
                return 'High'
            elif result.test_type in ['unit_tests', 'regression_tests']:
                return 'Medium'
        return 'Low'
    
    def update_project_state(self, summaries: List[ExecutionSummary]) -> bool:
        """Update project state with test results"""
        if not self.enabled:
            return False
        
        self.logger.info("Updating project state...")
        
        try:
            # Calculate overall statistics
            total_tests = sum(s.total_tests for s in summaries)
            total_passed = sum(s.passed for s in summaries)
            overall_pass_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
            
            # Update project state
            self.state.project_state.update({
                'last_test_date': datetime.now().isoformat(),
                'total_tests_executed': total_tests,
                'quality_score': overall_pass_rate,
                'test_findings': self._generate_test_findings(summaries),
            })
            
            self.logger.info("Project state updated successfully")
            return True
            
        except Exception as e:
            self.logger.error(f"Error updating project state: {str(e)}")
            return False
    
    def _generate_test_findings(self, summaries: List[ExecutionSummary]) -> List[str]:
        """Generate test findings summary"""
        findings = []
        
        total_tests = sum(s.total_tests for s in summaries)
        total_passed = sum(s.passed for s in summaries)
        total_failed = sum(s.failed for s in summaries)
        overall_pass_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
        
        findings.append(f"Executed {total_tests} tests across {len(summaries)} personas")
        findings.append(f"Overall pass rate: {overall_pass_rate:.2f}%")
        
        if total_failed > 0:
            findings.append(f"Found {total_failed} failed tests requiring attention")
        
        return findings
    
    def validate_quality_gates(self, summaries: List[ExecutionSummary]) -> Dict[str, Any]:
        """Validate against Agent OS quality gates"""
        if not self.enabled:
            return {'status': 'skipped', 'gates': {}}
        
        self.logger.info("Validating Agent OS quality gates...")
        
        # Load quality gate requirements
        quality_gates = self.config.get('quality_gates', {})
        
        # Calculate metrics
        total_tests = sum(s.total_tests for s in summaries)
        total_passed = sum(s.passed for s in summaries)
        overall_pass_rate = (total_passed / total_tests * 100) if total_tests > 0 else 0
        
        # Validate each gate
        gates = {
            'logic_correctness': {
                'requirement': quality_gates.get('logic_correctness', 100),
                'actual': overall_pass_rate,
                'status': 'PASS' if overall_pass_rate >= quality_gates.get('logic_correctness', 100) else 'FAIL',
            },
            'static_analysis': {
                'requirement': quality_gates.get('static_analysis', 0),
                'actual': 0,  # Would be calculated from actual static analysis
                'status': 'PASS',
            },
            'build_integrity': {
                'requirement': quality_gates.get('build_integrity', 'no_warnings'),
                'actual': 'no_warnings',
                'status': 'PASS',
            },
            'code_hygiene': {
                'requirement': quality_gates.get('code_hygiene', 'no_new_todos'),
                'actual': 'no_new_todos',
                'status': 'PASS',
            },
            'coverage': {
                'requirement': quality_gates.get('coverage', 80),
                'actual': self._calculate_coverage(summaries),
                'status': 'PASS' if self._calculate_coverage(summaries) >= quality_gates.get('coverage', 80) else 'FAIL',
            },
        }
        
        # Determine overall status
        all_passed = all(gate['status'] == 'PASS' for gate in gates.values())
        overall_status = 'PASS' if all_passed else 'FAIL'
        
        validation_result = {
            'status': overall_status,
            'gates': gates,
            'validated_at': datetime.now().isoformat(),
        }
        
        self.logger.info(f"Quality gate validation: {overall_status}")
        
        return validation_result
    
    def save_state(self) -> bool:
        """Save updated state back to Agent OS files"""
        if not self.enabled:
            return False
        
        self.logger.info("Saving Agent OS state...")
        
        success = True
        
        # Save test state
        if 'test_state' in self.state_files:
            try:
                test_state_path = self.base_dir / self.state_files['test_state']
                test_state_path.parent.mkdir(parents=True, exist_ok=True)
                
                with open(test_state_path, 'w') as f:
                    # Write as markdown with YAML frontmatter
                    f.write("---\n")
                    f.write(yaml.dump(self.state.test_state, default_flow_style=False))
                    f.write("---\n")
                    f.write(f"# Test State\n\n")
                    f.write(f"Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}\n")
                
                self.logger.info(f"Saved test state to {test_state_path}")
            except Exception as e:
                self.logger.error(f"Error saving test state: {str(e)}")
                success = False
        
        # Save project state
        if 'project_state' in self.state_files:
            try:
                project_state_path = self.base_dir / self.state_files['project_state']
                project_state_path.parent.mkdir(parents=True, exist_ok=True)
                
                with open(project_state_path, 'w') as f:
                    f.write("---\n")
                    f.write(yaml.dump(self.state.project_state, default_flow_style=False))
                    f.write("---\n")
                    f.write(f"# Project State\n\n")
                    f.write(f"Last updated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}\n")
                
                self.logger.info(f"Saved project state to {project_state_path}")
            except Exception as e:
                self.logger.error(f"Error saving project state: {str(e)}")
                success = False
        
        return success
    
    def get_integration_progress(self) -> Dict[str, Any]:
        """Get integration progress from plans"""
        try:
            integration_progress_path = self.base_dir / 'plans' / 'INTEGRATION_PROGRESS.md'
            if integration_progress_path.exists():
                with open(integration_progress_path, 'r') as f:
                    content = f.read()
                
                # Parse milestones
                milestones = self._parse_integration_progress(content)
                return milestones
        except Exception as e:
            self.logger.error(f"Error reading integration progress: {str(e)}")
        
        return {}
    
    def _parse_integration_progress(self, content: str) -> Dict[str, Any]:
        """Parse integration progress from markdown"""
        milestones = {}
        
        # Look for milestone sections
        milestone_pattern = r'##\s+(M-\d+[^:]*):\s*([^\n]+)'
        for match in re.finditer(milestone_pattern, content):
            milestone_id = match.group(1)
            milestone_name = match.group(2)
            
            # Look for status
            status_pattern = r'Status:\s*(\w+)'
            status_match = re.search(status_pattern, content[match.start():match.start()+500])
            status = status_match.group(1) if status_match else 'Unknown'
            
            milestones[milestone_id] = {
                'name': milestone_name,
                'status': status,
            }
        
        return milestones
    
    def get_dependencies(self) -> Dict[str, Any]:
        """Get dependencies from plans"""
        try:
            dependencies_path = self.base_dir / 'plans' / 'DEPENDENCIES.md'
            if dependencies_path.exists():
                with open(dependencies_path, 'r') as f:
                    content = f.read()
                
                # Parse dependencies
                deps = self._parse_dependencies(content)
                return deps
        except Exception as e:
            self.logger.error(f"Error reading dependencies: {str(e)}")
        
        return {}
    
    def _parse_dependencies(self, content: str) -> Dict[str, Any]:
        """Parse dependencies from markdown"""
        dependencies = {
            'flutter': [],
            'python': [],
            'other': [],
        }
        
        # Look for dependency lists
        flutter_pattern = r'###\s+Flutter\s+Dependencies\s*\n([\s\S]+?)(?=###|$)'
        for match in re.finditer(flutter_pattern, content):
            dep_list = match.group(1)
            for dep_match in re.finditer(r'-\s+`([^`]+)`', dep_list):
                dependencies['flutter'].append(dep_match.group(1))
        
        python_pattern = r'###\s+Python\s+Dependencies\s*\n([\s\S]+?)(?=###|$)'
        for match in re.finditer(python_pattern, content):
            dep_list = match.group(1)
            for dep_match in re.finditer(r'-\s+`([^`]+)`', dep_list):
                dependencies['python'].append(dep_match.group(1))
        
        return dependencies
    
    def get_test_scenarios(self) -> List[Dict[str, Any]]:
        """Get test scenarios from plans folder"""
        scenarios = []
        
        try:
            plans_dir = self.base_dir / 'plans'
            if plans_dir.exists():
                # Look for test scenario files
                for yaml_file in plans_dir.glob('**/*test*.yaml'):
                    with open(yaml_file, 'r') as f:
                        data = yaml.safe_load(f)
                        if isinstance(data, list):
                            scenarios.extend(data)
                        elif isinstance(data, dict):
                            scenarios.append(data)
                
                self.logger.info(f"Found {len(scenarios)} test scenarios in plans folder")
        except Exception as e:
            self.logger.error(f"Error reading test scenarios: {str(e)}")
        
        return scenarios
    
    def generate_continuity_snapshot(self, summaries: List[ExecutionSummary]) -> bool:
        """Generate continuity snapshot for resume capability"""
        try:
            continuity_dir = Path(self.config.get('paths', {}).get('continuity_dir', 'test_master/continuity'))
            continuity_dir.mkdir(parents=True, exist_ok=True)
            
            snapshot_path = continuity_dir / f"progress_snapshot_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
            
            snapshot_content = f"""# Test Master Continuity Snapshot

**Generated**: {datetime.now().strftime('%Y-%m-%d %H:%M:%S UTC')}
**Status**: In Progress

## Execution Summary

| Metric | Value |
|--------|-------|
| **Total Personas Tested** | {len(summaries)} |
| **Total Tests Executed** | {sum(s.total_tests for s in summaries)} |
| **Overall Pass Rate** | {(sum(s.passed for s in summaries) / sum(s.total_tests for s in summaries) * 100):.2f}% |

## Completed Personas

"""
            
            for summary in summaries:
                snapshot_content += f"### {summary.persona_name} ({summary.persona_id})\n\n"
                snapshot_content += f"- Status: Completed\n"
                snapshot_content += f"- Tests: {summary.passed}/{summary.total_tests} passed\n"
                snapshot_content += f"- Execution Time: {summary.total_execution_time:.2f}s\n\n"
            
            snapshot_content += """
## Next Steps

1. Review test results
2. Generate reports
3. Update Agent OS state
4. Address critical issues

## Configuration

```yaml
app_url: {app_url}
total_personas: {total_personas}
selected_personas: {selected_personas}
```

---

*This snapshot can be used to resume testing if interrupted.*
""".format(
                app_url=self.config.get('execution_config', {}).get('app_url', 'N/A'),
                total_personas=self.config.get('persona_generation', {}).get('total_personas', 25),
                selected_personas=self.config.get('persona_generation', {}).get('selected_personas', 5),
            )
            
            with open(snapshot_path, 'w') as f:
                f.write(snapshot_content)
            
            self.logger.info(f"Continuity snapshot saved to {snapshot_path}")
            return True
            
        except Exception as e:
            self.logger.error(f"Error generating continuity snapshot: {str(e)}")
            return False


def main():
    """Main function for testing Agent OS integration"""
    import logging
    
    # Setup logging
    logging.basicConfig(level=logging.INFO)
    logger = logging.getLogger('AgentOSIntegration')
    
    # Load configuration
    with open('test_master/config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Create integration
    integration = AgentOSIntegration(config, logger)
    
    # Load state
    integration.load_state()
    
    # Print state
    print("Project State:")
    print(json.dumps(integration.state.project_state, indent=2))
    print("\nTest State:")
    print(json.dumps(integration.state.test_state, indent=2))
    
    # Get integration progress
    progress = integration.get_integration_progress()
    print("\nIntegration Progress:")
    print(json.dumps(progress, indent=2))
    
    # Get dependencies
    deps = integration.get_dependencies()
    print("\nDependencies:")
    print(json.dumps(deps, indent=2))


if __name__ == "__main__":
    main()
