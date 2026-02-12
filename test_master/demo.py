"""
Test Master - Demo Script
Demonstrates the Test Master system capabilities
"""

import asyncio
import yaml
import logging
from pathlib import Path

from persona_generator import PersonaGenerator, Persona
from test_suite_generator import TestSuiteGenerator, TestSuite
from test_executor import TestExecutor, ExecutionSummary, TestStatus
from report_generator import ReportGenerator
from agent_os_integration import AgentOSIntegration


async def demo_persona_generation():
    """Demo: Persona Generation"""
    print("\n" + "="*60)
    print("DEMO 1: Persona Generation")
    print("="*60)
    
    # Create persona generator
    generator = PersonaGenerator(seed=42)
    
    # Generate 25 personas
    print("\nGenerating 25 diverse personas...")
    personas = generator.generate_personas(25)
    print(f"✓ Generated {len(personas)} personas")
    
    # Display statistics
    print("\nPersona Statistics:")
    print(f"  Age Groups: {set(p.age_group for p in personas)}")
    print(f"  Technology Experience: {set(p.technology_experience for p in personas)}")
    print(f"  Behaviors: {set(p.behavior for p in personas)}")
    print(f"  Testing Styles: {set(p.testing_style for p in personas)}")
    print(f"  Roles: {set(p.role for p in personas)}")
    print(f"  Agent Profiles: {set(p.agent_profile for p in personas)}")
    print(f"  Accessibility Users: {sum(1 for p in personas if p.technology_experience == 'Accessibility User')}")
    print(f"  Security-Focused: {sum(1 for p in personas if p.testing_style == 'Security-Focused')}")
    
    # Select 5 diverse personas
    print("\nSelecting 5 diverse personas...")
    selected = generator.select_diverse_personas(5)
    print(f"✓ Selected {len(selected)} personas:")
    
    for i, persona in enumerate(selected, 1):
        print(f"  {i}. {persona.persona_id}: {persona.name}")
        print(f"     - Experience: {persona.technology_experience}")
        print(f"     - Behavior: {persona.behavior}")
        print(f"     - Testing Style: {persona.testing_style}")
        print(f"     - Role: {persona.role}")
        print(f"     - Agent Profile: {persona.agent_profile}")
    
    # Save personas
    print("\nSaving personas to test_master/personas/...")
    generator.save_personas("test_master/personas")
    print("✓ Personas saved successfully")
    
    return selected


async def demo_test_suite_generation(personas):
    """Demo: Test Suite Generation"""
    print("\n" + "="*60)
    print("DEMO 2: Test Suite Generation")
    print("="*60)
    
    # Load configuration
    with open('test_master/config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Create test suite generator
    generator = TestSuiteGenerator(config)
    
    # Generate test suites for selected personas
    test_suites = []
    for persona in personas:
        print(f"\nGenerating test suite for {persona.persona_id}: {persona.name}")
        
        test_suite = generator.generate_test_suite(persona)
        test_suites.append(test_suite)
        
        print(f"✓ Generated {len(test_suite.test_cases)} test cases")
        
        # Show test type breakdown
        test_types = {}
        for test_case in test_suite.test_cases:
            if test_case.test_type not in test_types:
                test_types[test_case.test_type] = 0
            test_types[test_case.test_type] += 1
        
        print(f"  Test Types:")
        for test_type, count in sorted(test_types.items()):
            print(f"    - {test_type}: {count}")
        
        # Save test suite
        generator.save_test_suite(test_suite, "test_master/test_suites")
        print(f"✓ Test suite saved")
    
    print(f"\n✓ Generated {len(test_suites)} test suites total")
    return test_suites


async def demo_report_generation(personas, test_suites):
    """Demo: Report Generation"""
    print("\n" + "="*60)
    print("DEMO 3: Report Generation")
    print("="*60)
    
    # Load configuration
    with open('test_master/config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Setup logging
    logging.basicConfig(level=logging.WARNING)  # Suppress verbose logs for demo
    logger = logging.getLogger('ReportGenerator')
    
    # Create report generator
    report_gen = ReportGenerator(config, logger)
    
    # Create mock summaries for demo
    summaries = []
    for persona, test_suite in zip(personas, test_suites):
        summary = ExecutionSummary(
            persona_id=persona.persona_id,
            persona_name=persona.name,
            execution_date="2024-01-01T12:00:00Z",
            total_tests=len(test_suite.test_cases),
            passed=int(len(test_suite.test_cases) * 0.85),
            failed=int(len(test_suite.test_cases) * 0.10),
            skipped=int(len(test_suite.test_cases) * 0.05),
            errors=0,
            pass_rate=85.0,
            total_execution_time=120.5,
        )
        summaries.append(summary)
    
    # Generate persona reports
    print("\nGenerating persona reports...")
    for persona, test_suite, summary in zip(personas, test_suites, summaries):
        report_path = report_gen.generate_persona_report(persona, test_suite, summary)
        print(f"✓ Generated persona report: {report_path}")
    
    # Generate manager report
    print("\nGenerating manager-level comprehensive report...")
    manager_report_path = report_gen.generate_manager_report(personas, summaries, config)
    print(f"✓ Generated manager report: {manager_report_path}")
    
    return summaries


async def demo_agent_os_integration(summaries):
    """Demo: Agent OS Integration"""
    print("\n" + "="*60)
    print("DEMO 4: Agent OS Integration")
    print("="*60)
    
    # Load configuration
    with open('test_master/config.yaml', 'r') as f:
        config = yaml.safe_load(f)
    
    # Setup logging
    logging.basicConfig(level=logging.WARNING)
    logger = logging.getLogger('AgentOSIntegration')
    
    # Create integration
    integration = AgentOSIntegration(config, logger)
    
    # Try to load state
    print("\nAttempting to load Agent OS state...")
    success = integration.load_state()
    if success:
        print("✓ Agent OS state loaded successfully")
        print(f"  Project state: {len(integration.state.project_state)} keys")
        print(f"  Test state: {len(integration.state.test_state)} keys")
        print(f"  Backlog state: {len(integration.state.backlog_state)} keys")
    else:
        print("⚠ Agent OS integration not available (state files not found)")
        print("  This is normal if Agent OS is not configured")
    
    # Validate quality gates
    print("\nValidating Agent OS quality gates...")
    validation_result = integration.validate_quality_gates(summaries)
    print(f"✓ Quality gate validation: {validation_result['status']}")
    
    print("\n  Gate Results:")
    for gate_name, gate_result in validation_result['gates'].items():
        status_icon = "✓" if gate_result['status'] == 'PASS' else "✗"
        print(f"    {status_icon} {gate_name}: {gate_result['status']}")
        print(f"      Requirement: {gate_result['requirement']}")
        print(f"      Actual: {gate_result['actual']}")
    
    # Generate continuity snapshot
    print("\nGenerating continuity snapshot...")
    success = integration.generate_continuity_snapshot(summaries)
    if success:
        print("✓ Continuity snapshot generated")
    else:
        print("✗ Failed to generate continuity snapshot")


async def demo_full_workflow():
    """Demo: Complete Test Master Workflow"""
    print("\n" + "="*60)
    print("TEST MASTER DEMO - Complete Workflow")
    print("="*60)
    print("\nThis demo showcases all major components of Test Master:")
    print("1. Persona Generation")
    print("2. Test Suite Generation")
    print("3. Report Generation")
    print("4. Agent OS Integration")
    print("\nNote: Actual test execution is skipped in demo mode.")
    print("      Run 'python test_master/test_master.py' for full execution.")
    
    try:
        # Demo 1: Persona Generation
        personas = await demo_persona_generation()
        
        # Demo 2: Test Suite Generation
        test_suites = await demo_test_suite_generation(personas)
        
        # Demo 3: Report Generation
        summaries = await demo_report_generation(personas, test_suites)
        
        # Demo 4: Agent OS Integration
        await demo_agent_os_integration(summaries)
        
        # Final Summary
        print("\n" + "="*60)
        print("DEMO COMPLETED SUCCESSFULLY")
        print("="*60)
        print("\nGenerated Artifacts:")
        print("  ✓ 25 personas in test_master/personas/")
        print("  ✓ 5 test suites in test_master/test_suites/")
        print("  ✓ 5 persona reports in test_master/reports/persona/")
        print("  ✓ 1 manager report in test_master/reports/manager/")
        print("\nNext Steps:")
        print("  1. Review generated reports")
        print("  2. Customize configuration in test_master/config.yaml")
        print("  3. Run full test execution: python test_master/test_master.py")
        print("  4. Check documentation: test_master/README.md")
        
    except Exception as e:
        print(f"\n✗ Demo failed with error: {str(e)}")
        import traceback
        traceback.print_exc()


async def demo_quick_example():
    """Demo: Quick Example with Minimal Output"""
    print("\n" + "="*60)
    print("QUICK EXAMPLE - Minimal Test Master Demo")
    print("="*60)
    
    # Generate a single persona
    print("\n1. Generating 1 persona...")
    generator = PersonaGenerator(seed=123)
    personas = generator.generate_personas(1)
    persona = personas[0]
    print(f"✓ Generated: {persona.name} ({persona.persona_id})")
    print(f"  Experience: {persona.technology_experience}")
    print(f"  Behavior: {persona.behavior}")
    print(f"  Testing Style: {persona.testing_style}")
    
    # Generate a small test suite
    print("\n2. Generating test suite...")
    config = {'features': [], 'test_types': ['unit_tests', 'integration_tests']}
    suite_gen = TestSuiteGenerator(config)
    test_suite = suite_gen.generate_test_suite(persona)
    print(f"✓ Generated {len(test_suite.test_cases)} test cases")
    
    # Show sample test case
    if test_suite.test_cases:
        sample = test_suite.test_cases[0]
        print(f"\n3. Sample Test Case:")
        print(f"  ID: {sample.test_id}")
        print(f"  Type: {sample.test_type}")
        print(f"  Title: {sample.title}")
        print(f"  Priority: {sample.priority}")
        print(f"  Steps: {len(sample.test_steps)}")
    
    print("\n✓ Quick example completed!")
    print("\nTo run the full system:")
    print("  python test_master/test_master.py")


def main():
    """Main entry point for demo"""
    import argparse
    
    parser = argparse.ArgumentParser(description='Test Master Demo')
    parser.add_argument('--mode', '-m', choices=['full', 'quick'],
                        default='full', help='Demo mode')
    
    args = parser.parse_args()
    
    if args.mode == 'full':
        asyncio.run(demo_full_workflow())
    else:
        asyncio.run(demo_quick_example())


if __name__ == "__main__":
    main()
