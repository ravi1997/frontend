"""
Test Master - Test Suite Generator
Generates comprehensive test suites for each persona
"""

import yaml
import random
from typing import List, Dict, Any, Optional
from dataclasses import dataclass, field, asdict
from pathlib import Path
from datetime import datetime
from persona_generator import Persona


@dataclass
class TestStep:
    """Represents a single test step"""
    step: int
    action: str
    expected: str
    optional: bool = False
    
    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)


@dataclass
class TestCase:
    """Represents a single test case"""
    test_id: str
    test_type: str
    persona_id: str
    title: str
    priority: str
    description: str
    preconditions: List[str]
    test_steps: List[TestStep]
    test_data: Dict[str, Any]
    expected_result: str
    acceptance_criteria: List[str]
    related_requirements: List[str]
    related_backlog_items: List[str]
    tags: List[str]
    estimated_duration: int  # in seconds
    
    def to_dict(self) -> Dict[str, Any]:
        data = asdict(self)
        data['test_steps'] = [step.to_dict() for step in self.test_steps]
        return data


@dataclass
class TestSuite:
    """Represents a complete test suite for a persona"""
    suite_id: str
    persona_id: str
    persona_name: str
    generated_at: str
    test_cases: List[TestCase] = field(default_factory=list)
    
    def to_dict(self) -> Dict[str, Any]:
        data = asdict(self)
        data['test_cases'] = [test.to_dict() for test in self.test_cases]
        return data
    
    def to_yaml(self) -> str:
        return yaml.dump(self.to_dict(), default_flow_style=False, sort_keys=False)
    
    def get_tests_by_type(self, test_type: str) -> List[TestCase]:
        """Get all tests of a specific type"""
        return [t for t in self.test_cases if t.test_type == test_type]
    
    def get_tests_by_priority(self, priority: str) -> List[TestCase]:
        """Get all tests of a specific priority"""
        return [t for t in self.test_cases if t.priority == priority]


class TestSuiteGenerator:
    """Generates test suites for personas"""
    
    TEST_TYPES = [
        "unit_tests",
        "integration_tests",
        "system_tests",
        "regression_tests",
        "ui_tests",
        "impression_tests",
        "usability_tests",
        "exploratory_tests",
        "performance_tests",
        "security_tests",
        "accessibility_tests",
        "expected_failure_cases",
    ]
    
    PRIORITIES = ["Critical", "High", "Medium", "Low"]
    
    # Common test data templates
    TEST_DATA_TEMPLATES = {
        "valid_form_data": {
            "name": "John Doe",
            "email": "john.doe@example.com",
            "phone": "+1234567890",
            "message": "This is a test message"
        },
        "invalid_email": {
            "email": "invalid-email"
        },
        "long_text": {
            "text": "A" * 10000
        },
        "special_chars": {
            "text": "<script>alert('xss')</script>&\"'<>"
        },
        "sql_injection": {
            "input": "'; DROP TABLE users; --"
        },
    }
    
    # Test step templates for common actions
    STEP_TEMPLATES = {
        "navigate": "Navigate to {url}",
        "click": "Click on {element}",
        "type": "Type '{text}' into {element}",
        "select": "Select '{option}' from {element}",
        "wait": "Wait for {element} to be visible",
        "verify": "Verify that {element} is {state}",
        "screenshot": "Take screenshot of current state",
    }
    
    def __init__(self, config: Dict[str, Any]):
        """Initialize test suite generator with configuration"""
        self.config = config
        self.features = config.get('features', [])
        self.test_types = config.get('test_types', self.TEST_TYPES)
    
    def generate_test_suite(self, persona: Persona) -> TestSuite:
        """Generate a complete test suite for a persona"""
        suite = TestSuite(
            suite_id=f"SUITE-{persona.persona_id}",
            persona_id=persona.persona_id,
            persona_name=persona.name,
            generated_at=datetime.now().isoformat(),
        )
        
        # Generate tests for each test type
        for test_type in self.test_types:
            test_cases = self._generate_test_cases_for_type(persona, test_type)
            suite.test_cases.extend(test_cases)
        
        return suite
    
    def _generate_test_cases_for_type(self, persona: Persona, test_type: str) -> List[TestCase]:
        """Generate test cases for a specific test type"""
        test_cases = []
        
        if test_type == "unit_tests":
            test_cases.extend(self._generate_unit_tests(persona))
        elif test_type == "integration_tests":
            test_cases.extend(self._generate_integration_tests(persona))
        elif test_type == "system_tests":
            test_cases.extend(self._generate_system_tests(persona))
        elif test_type == "regression_tests":
            test_cases.extend(self._generate_regression_tests(persona))
        elif test_type == "ui_tests":
            test_cases.extend(self._generate_ui_tests(persona))
        elif test_type == "impression_tests":
            test_cases.extend(self._generate_impression_tests(persona))
        elif test_type == "usability_tests":
            test_cases.extend(self._generate_usability_tests(persona))
        elif test_type == "exploratory_tests":
            test_cases.extend(self._generate_exploratory_tests(persona))
        elif test_type == "performance_tests":
            test_cases.extend(self._generate_performance_tests(persona))
        elif test_type == "security_tests":
            test_cases.extend(self._generate_security_tests(persona))
        elif test_type == "accessibility_tests":
            test_cases.extend(self._generate_accessibility_tests(persona))
        elif test_type == "expected_failure_cases":
            test_cases.extend(self._generate_failure_cases(persona))
        
        return test_cases
    
    def _generate_unit_tests(self, persona: Persona) -> List[TestCase]:
        """Generate unit tests for a persona"""
        tests = []
        
        # Form validation unit tests
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-UNIT-001",
            test_type="unit_tests",
            persona_id=persona.persona_id,
            title="Email Validation - Valid Email",
            priority="High",
            description="Validate that a valid email format is accepted",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Input valid email 'test@example.com'", "Email is accepted"),
                TestStep(2, "Submit form", "Form submission succeeds"),
            ],
            test_data={"email": "test@example.com"},
            expected_result="Email validation passes",
            acceptance_criteria=["Valid email is accepted", "No validation error shown"],
            related_requirements=["REQ-FORM-001"],
            related_backlog_items=["BL-001"],
            tags=["validation", "email", "unit"],
            estimated_duration=5,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-UNIT-002",
            test_type="unit_tests",
            persona_id=persona.persona_id,
            title="Email Validation - Invalid Email",
            priority="High",
            description="Validate that an invalid email format is rejected",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Input invalid email 'invalid-email'", "Email is rejected"),
                TestStep(2, "Submit form", "Form submission fails with error"),
            ],
            test_data={"email": "invalid-email"},
            expected_result="Email validation fails with appropriate error message",
            acceptance_criteria=["Invalid email is rejected", "Error message is shown"],
            related_requirements=["REQ-FORM-001"],
            related_backlog_items=["BL-001"],
            tags=["validation", "email", "unit"],
            estimated_duration=5,
        ))
        
        # Phone number validation
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-UNIT-003",
            test_type="unit_tests",
            persona_id=persona.persona_id,
            title="Phone Number Validation - Valid Format",
            priority="Medium",
            description="Validate that a valid phone number format is accepted",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Input valid phone number '+1234567890'", "Phone number is accepted"),
                TestStep(2, "Submit form", "Form submission succeeds"),
            ],
            test_data={"phone": "+1234567890"},
            expected_result="Phone number validation passes",
            acceptance_criteria=["Valid phone number is accepted", "No validation error shown"],
            related_requirements=["REQ-FORM-002"],
            related_backlog_items=["BL-002"],
            tags=["validation", "phone", "unit"],
            estimated_duration=5,
        ))
        
        return tests
    
    def _generate_integration_tests(self, persona: Persona) -> List[TestCase]:
        """Generate integration tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-INT-001",
            test_type="integration_tests",
            persona_id=persona.persona_id,
            title="Form Submission with API Integration",
            priority="Critical",
            description="Test complete form submission flow with API integration",
            preconditions=["User is logged in", "Form is loaded"],
            test_steps=[
                TestStep(1, "Fill all required form fields", "Fields are populated"),
                TestStep(2, "Submit form", "API request is sent"),
                TestStep(3, "Wait for response", "Response is received"),
                TestStep(4, "Verify success message", "Success message is displayed"),
            ],
            test_data=self.TEST_DATA_TEMPLATES["valid_form_data"],
            expected_result="Form is submitted successfully and data is saved",
            acceptance_criteria=["API request succeeds", "Data is persisted", "Success message shown"],
            related_requirements=["REQ-API-001", "REQ-FORM-003"],
            related_backlog_items=["BL-003"],
            tags=["integration", "api", "form"],
            estimated_duration=15,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-INT-002",
            test_type="integration_tests",
            persona_id=persona.persona_id,
            title="Analytics Dashboard Data Integration",
            priority="High",
            description="Test analytics dashboard with real data integration",
            preconditions=["User is logged in", "Analytics data exists"],
            test_steps=[
                TestStep(1, "Navigate to analytics dashboard", "Dashboard loads"),
                TestStep(2, "Wait for data to load", "Data is fetched and displayed"),
                TestStep(3, "Verify charts render", "Charts are visible"),
                TestStep(4, "Click on chart element", "Detailed view opens"),
            ],
            test_data={},
            expected_result="Analytics dashboard displays real-time data correctly",
            acceptance_criteria=["Data loads successfully", "Charts render correctly", "Interactions work"],
            related_requirements=["REQ-ANALYTICS-001"],
            related_backlog_items=["BL-004"],
            tags=["integration", "analytics", "dashboard"],
            estimated_duration=20,
        ))
        
        return tests
    
    def _generate_system_tests(self, persona: Persona) -> List[TestCase]:
        """Generate system tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-SYS-001",
            test_type="system_tests",
            persona_id=persona.persona_id,
            title="Complete User Registration Flow",
            priority="Critical",
            description="Test end-to-end user registration and onboarding flow",
            preconditions=["Application is running", "User is not registered"],
            test_steps=[
                TestStep(1, "Navigate to registration page", "Registration form loads"),
                TestStep(2, "Fill registration form with valid data", "Fields are populated"),
                TestStep(3, "Submit registration", "Account is created"),
                TestStep(4, "Verify email confirmation", "Confirmation email is sent"),
                TestStep(5, "Login with new credentials", "User is logged in"),
                TestStep(6, "Complete onboarding", "Onboarding is complete"),
            ],
            test_data={
                "name": "Test User",
                "email": "testuser@example.com",
                "password": "SecurePass123!",
            },
            expected_result="User can complete full registration and onboarding flow",
            acceptance_criteria=["Account created successfully", "Email sent", "Login works", "Onboarding complete"],
            related_requirements=["REQ-AUTH-001", "REQ-ONBOARD-001"],
            related_backlog_items=["BL-005"],
            tags=["system", "registration", "onboarding"],
            estimated_duration=60,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-SYS-002",
            test_type="system_tests",
            persona_id=persona.persona_id,
            title="Form Creation to Publication Flow",
            priority="Critical",
            description="Test complete form creation, editing, and publication flow",
            preconditions=["User is logged in", "User has form creation permissions"],
            test_steps=[
                TestStep(1, "Navigate to form builder", "Form builder loads"),
                TestStep(2, "Add form fields", "Fields are added"),
                TestStep(3, "Configure field properties", "Properties are set"),
                TestStep(4, "Save form draft", "Draft is saved"),
                TestStep(5, "Preview form", "Preview displays correctly"),
                TestStep(6, "Publish form", "Form is published"),
                TestStep(7, "Verify form is accessible", "Form can be accessed"),
            ],
            test_data={},
            expected_result="User can create, edit, and publish a form successfully",
            acceptance_criteria=["Form created", "Fields configured", "Draft saved", "Published successfully"],
            related_requirements=["REQ-FORM-BUILDER-001"],
            related_backlog_items=["BL-006"],
            tags=["system", "form-builder", "publishing"],
            estimated_duration=90,
        ))
        
        return tests
    
    def _generate_regression_tests(self, persona: Persona) -> List[TestCase]:
        """Generate regression tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-REG-001",
            test_type="regression_tests",
            persona_id=persona.persona_id,
            title="Existing Form Loading - Regression",
            priority="High",
            description="Verify existing forms still load correctly after recent changes",
            preconditions=["Existing forms exist in database"],
            test_steps=[
                TestStep(1, "Navigate to forms list", "List loads"),
                TestStep(2, "Click on existing form", "Form loads"),
                TestStep(3, "Verify form structure", "Form structure is intact"),
                TestStep(4, "Verify form data", "Data is correct"),
            ],
            test_data={},
            expected_result="Existing forms load and display correctly",
            acceptance_criteria=["Form loads", "Structure intact", "Data correct"],
            related_requirements=["REQ-FORM-004"],
            related_backlog_items=["BL-007"],
            tags=["regression", "form-loading"],
            estimated_duration=30,
        ))
        
        return tests
    
    def _generate_ui_tests(self, persona: Persona) -> List[TestCase]:
        """Generate UI tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-UI-001",
            test_type="ui_tests",
            persona_id=persona.persona_id,
            title="Responsive Design - Desktop Viewport",
            priority="High",
            description="Test UI rendering on desktop viewport",
            preconditions=["Application is running"],
            test_steps=[
                TestStep(1, "Set viewport to 1920x1080", "Viewport is set"),
                TestStep(2, "Navigate to homepage", "Page loads"),
                TestStep(3, "Verify layout", "Layout is correct"),
                TestStep(4, "Verify all elements visible", "All elements are visible"),
                TestStep(5, "Take screenshot", "Screenshot captured"),
            ],
            test_data={"viewport": {"width": 1920, "height": 1080}},
            expected_result="UI renders correctly on desktop viewport",
            acceptance_criteria=["Layout correct", "All elements visible", "No overflow"],
            related_requirements=["REQ-UI-001"],
            related_backlog_items=["BL-008"],
            tags=["ui", "responsive", "desktop"],
            estimated_duration=10,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-UI-002",
            test_type="ui_tests",
            persona_id=persona.persona_id,
            title="Responsive Design - Mobile Viewport",
            priority="High",
            description="Test UI rendering on mobile viewport",
            preconditions=["Application is running"],
            test_steps=[
                TestStep(1, "Set viewport to 375x667", "Viewport is set"),
                TestStep(2, "Navigate to homepage", "Page loads"),
                TestStep(3, "Verify layout", "Layout is adapted for mobile"),
                TestStep(4, "Verify navigation", "Navigation is mobile-friendly"),
                TestStep(5, "Take screenshot", "Screenshot captured"),
            ],
            test_data={"viewport": {"width": 375, "height": 667}},
            expected_result="UI renders correctly on mobile viewport",
            acceptance_criteria=["Layout adapted", "Navigation mobile-friendly", "No horizontal scroll"],
            related_requirements=["REQ-UI-002"],
            related_backlog_items=["BL-008"],
            tags=["ui", "responsive", "mobile"],
            estimated_duration=10,
        ))
        
        return tests
    
    def _generate_impression_tests(self, persona: Persona) -> List[TestCase]:
        """Generate impression tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-IMP-001",
            test_type="impression_tests",
            persona_id=persona.persona_id,
            title="First Impression - Homepage",
            priority="Medium",
            description="Evaluate first impression of homepage from persona's perspective",
            preconditions=["User is not logged in"],
            test_steps=[
                TestStep(1, "Navigate to homepage", "Page loads"),
                TestStep(2, "Observe initial impression", "Record observations"),
                TestStep(3, "Evaluate clarity", "Assess clarity of purpose"),
                TestStep(4, "Evaluate visual appeal", "Assess visual design"),
                TestStep(5, "Evaluate navigation", "Assess navigation clarity"),
            ],
            test_data={},
            expected_result="Homepage creates positive first impression",
            acceptance_criteria=["Purpose is clear", "Design is appealing", "Navigation is intuitive"],
            related_requirements=["REQ-UX-001"],
            related_backlog_items=["BL-009"],
            tags=["impression", "ux", "homepage"],
            estimated_duration=30,
        ))
        
        return tests
    
    def _generate_usability_tests(self, persona: Persona) -> List[TestCase]:
        """Generate usability tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-USAB-001",
            test_type="usability_tests",
            persona_id=persona.persona_id,
            title="Task Completion - Create Simple Form",
            priority="High",
            description="Measure task completion rate for creating a simple form",
            preconditions=["User is logged in"],
            test_steps=[
                TestStep(1, "Start timer", "Timer starts"),
                TestStep(2, "Navigate to form builder", "Form builder loads"),
                TestStep(3, "Add text field", "Field is added"),
                TestStep(4, "Add email field", "Field is added"),
                TestStep(5, "Save form", "Form is saved"),
                TestStep(6, "Stop timer", "Timer stops"),
                TestStep(7, "Record completion time", "Time is recorded"),
            ],
            test_data={},
            expected_result="Task can be completed within acceptable time",
            acceptance_criteria=["Task completed", "Time within threshold", "No errors encountered"],
            related_requirements=["REQ-USAB-001"],
            related_backlog_items=["BL-010"],
            tags=["usability", "task-completion", "form-builder"],
            estimated_duration=45,
        ))
        
        return tests
    
    def _generate_exploratory_tests(self, persona: Persona) -> List[TestCase]:
        """Generate exploratory tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-EXP-001",
            test_type="exploratory_tests",
            persona_id=persona.persona_id,
            title="Edge Case Discovery - Form Inputs",
            priority="Medium",
            description="Explore edge cases in form input handling",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Input maximum length text", "Text is accepted or rejected appropriately"),
                TestStep(2, "Input special characters", "Characters are handled correctly"),
                TestStep(3, "Input unicode characters", "Characters are handled correctly"),
                TestStep(4, "Input empty values", "Validation works correctly"),
                TestStep(5, "Input null values", "Validation works correctly"),
                TestStep(6, "Document any unexpected behavior", "Behavior is documented"),
            ],
            test_data={
                "max_length": "A" * 10000,
                "special_chars": "!@#$%^&*()_+-=[]{}|;':\",./<>?",
                "unicode": "你好世界こんにちは안녕하세요مرحبا",
            },
            expected_result="All edge cases are handled gracefully",
            acceptance_criteria=["No crashes", "Appropriate validation", "Clear error messages"],
            related_requirements=["REQ-EDGE-001"],
            related_backlog_items=["BL-011"],
            tags=["exploratory", "edge-case", "form-input"],
            estimated_duration=60,
        ))
        
        return tests
    
    def _generate_performance_tests(self, persona: Persona) -> List[TestCase]:
        """Generate performance tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-PERF-001",
            test_type="performance_tests",
            persona_id=persona.persona_id,
            title="Page Load Time - Homepage",
            priority="High",
            description="Measure homepage load time",
            preconditions=["Application is running"],
            test_steps=[
                TestStep(1, "Clear browser cache", "Cache is cleared"),
                TestStep(2, "Navigate to homepage", "Navigation starts"),
                TestStep(3, "Measure load time", "Load time is recorded"),
                TestStep(4, "Verify load time is acceptable", "Time is within threshold"),
            ],
            test_data={"threshold_ms": 3000},
            expected_result="Homepage loads within acceptable time threshold",
            acceptance_criteria=["Load time < 3 seconds", "No blocking resources"],
            related_requirements=["REQ-PERF-001"],
            related_backlog_items=["BL-012"],
            tags=["performance", "load-time", "homepage"],
            estimated_duration=15,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-PERF-002",
            test_type="performance_tests",
            persona_id=persona.persona_id,
            title="Form Submission Response Time",
            priority="High",
            description="Measure form submission response time",
            preconditions=["User is logged in", "Form is loaded"],
            test_steps=[
                TestStep(1, "Fill form with test data", "Form is filled"),
                TestStep(2, "Submit form", "Submission starts"),
                TestStep(3, "Measure response time", "Response time is recorded"),
                TestStep(4, "Verify response time is acceptable", "Time is within threshold"),
            ],
            test_data=self.TEST_DATA_TEMPLATES["valid_form_data"],
            expected_result="Form submission responds within acceptable time threshold",
            acceptance_criteria=["Response time < 2 seconds", "Success message shown"],
            related_requirements=["REQ-PERF-002"],
            related_backlog_items=["BL-012"],
            tags=["performance", "response-time", "form-submission"],
            estimated_duration=20,
        ))
        
        return tests
    
    def _generate_security_tests(self, persona: Persona) -> List[TestCase]:
        """Generate security tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-SEC-001",
            test_type="security_tests",
            persona_id=persona.persona_id,
            title="XSS Prevention - Form Input",
            priority="Critical",
            description="Test XSS prevention in form input fields",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Input XSS payload into text field", "Input is accepted"),
                TestStep(2, "Submit form", "Form is submitted"),
                TestStep(3, "Verify payload is sanitized", "Payload is not executed"),
                TestStep(4, "Verify data is stored safely", "Data is escaped in storage"),
            ],
            test_data=self.TEST_DATA_TEMPLATES["special_chars"],
            expected_result="XSS payload is sanitized and not executed",
            acceptance_criteria=["Payload not executed", "Data properly escaped", "No script injection"],
            related_requirements=["REQ-SEC-001"],
            related_backlog_items=["BL-013"],
            tags=["security", "xss", "input-validation"],
            estimated_duration=15,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-SEC-002",
            test_type="security_tests",
            persona_id=persona.persona_id,
            title="SQL Injection Prevention",
            priority="Critical",
            description="Test SQL injection prevention",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Input SQL injection payload", "Input is accepted"),
                TestStep(2, "Submit form", "Form is submitted"),
                TestStep(3, "Verify query is parameterized", "Injection is prevented"),
                TestStep(4, "Verify database integrity", "No data is compromised"),
            ],
            test_data=self.TEST_DATA_TEMPLATES["sql_injection"],
            expected_result="SQL injection is prevented",
            acceptance_criteria=["Injection prevented", "Database intact", "No unauthorized access"],
            related_requirements=["REQ-SEC-002"],
            related_backlog_items=["BL-013"],
            tags=["security", "sql-injection", "input-validation"],
            estimated_duration=15,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-SEC-003",
            test_type="security_tests",
            persona_id=persona.persona_id,
            title="Authentication - Invalid Credentials",
            priority="High",
            description="Test authentication with invalid credentials",
            preconditions=["Login page is loaded"],
            test_steps=[
                TestStep(1, "Enter invalid username", "Username is entered"),
                TestStep(2, "Enter invalid password", "Password is entered"),
                TestStep(3, "Submit login", "Login attempt is made"),
                TestStep(4, "Verify error message", "Error message is shown"),
                TestStep(5, "Verify account is not accessed", "Access is denied"),
            ],
            test_data={"username": "invalid", "password": "invalid"},
            expected_result="Invalid credentials are rejected",
            acceptance_criteria=["Error message shown", "Access denied", "No session created"],
            related_requirements=["REQ-AUTH-002"],
            related_backlog_items=["BL-014"],
            tags=["security", "authentication", "login"],
            estimated_duration=10,
        ))
        
        return tests
    
    def _generate_accessibility_tests(self, persona: Persona) -> List[TestCase]:
        """Generate accessibility tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-A11Y-001",
            test_type="accessibility_tests",
            persona_id=persona.persona_id,
            title="Keyboard Navigation - Form Fields",
            priority="High",
            description="Test keyboard navigation through form fields",
            preconditions=["Form is loaded"],
            test_steps=[
                TestStep(1, "Press Tab to navigate", "Focus moves to next field"),
                TestStep(2, "Verify focus indicator", "Focus indicator is visible"),
                TestStep(3, "Navigate through all fields", "All fields are reachable"),
                TestStep(4, "Verify logical tab order", "Tab order is logical"),
            ],
            test_data={},
            expected_result="All form fields are accessible via keyboard",
            acceptance_criteria=["All fields reachable", "Focus visible", "Logical tab order"],
            related_requirements=["REQ-A11Y-001"],
            related_backlog_items=["BL-015"],
            tags=["accessibility", "keyboard", "navigation"],
            estimated_duration=20,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-A11Y-002",
            test_type="accessibility_tests",
            persona_id=persona.persona_id,
            title="Screen Reader - Form Labels",
            priority="High",
            description="Test screen reader compatibility for form labels",
            preconditions=["Screen reader is active", "Form is loaded"],
            test_steps=[
                TestStep(1, "Navigate to form field", "Screen reader announces label"),
                TestStep(2, "Verify label clarity", "Label is clear and descriptive"),
                TestStep(3, "Navigate to all fields", "All fields have labels"),
                TestStep(4, "Verify ARIA attributes", "ARIA attributes are correct"),
            ],
            test_data={},
            expected_result="All form fields have accessible labels",
            acceptance_criteria=["Labels announced", "Labels clear", "ARIA correct"],
            related_requirements=["REQ-A11Y-002"],
            related_backlog_items=["BL-015"],
            tags=["accessibility", "screen-reader", "labels"],
            estimated_duration=25,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-A11Y-003",
            test_type="accessibility_tests",
            persona_id=persona.persona_id,
            title="Color Contrast - Text Elements",
            priority="Medium",
            description="Test color contrast of text elements",
            preconditions=["Page is loaded"],
            test_steps=[
                TestStep(1, "Analyze text elements", "Elements are identified"),
                TestStep(2, "Measure color contrast", "Contrast ratio is calculated"),
                TestStep(3, "Verify WCAG compliance", "Contrast meets WCAG AA"),
                TestStep(4, "Document any failures", "Failures are documented"),
            ],
            test_data={"wcag_level": "AA", "min_contrast": 4.5},
            expected_result="All text elements meet WCAG AA color contrast requirements",
            acceptance_criteria=["Contrast >= 4.5:1", "WCAG AA compliant"],
            related_requirements=["REQ-A11Y-003"],
            related_backlog_items=["BL-015"],
            tags=["accessibility", "color-contrast", "wcag"],
            estimated_duration=15,
        ))
        
        return tests
    
    def _generate_failure_cases(self, persona: Persona) -> List[TestCase]:
        """Generate expected failure case tests for a persona"""
        tests = []
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-FAIL-001",
            test_type="expected_failure_cases",
            persona_id=persona.persona_id,
            title="Network Failure - Form Submission",
            priority="High",
            description="Test behavior when network fails during form submission",
            preconditions=["Form is filled", "Network is available"],
            test_steps=[
                TestStep(1, "Simulate network failure", "Network is disconnected"),
                TestStep(2, "Submit form", "Submission fails"),
                TestStep(3, "Verify error handling", "Error message is shown"),
                TestStep(4, "Verify data preservation", "Form data is preserved"),
                TestStep(5, "Retry submission", "Retry option is available"),
            ],
            test_data={},
            expected_result="Network failure is handled gracefully with retry option",
            acceptance_criteria=["Error shown", "Data preserved", "Retry available"],
            related_requirements=["REQ-RESILIENCE-001"],
            related_backlog_items=["BL-016"],
            tags=["failure-case", "network", "resilience"],
            estimated_duration=20,
        ))
        
        tests.append(TestCase(
            test_id=f"T-{persona.persona_id}-FAIL-002",
            test_type="expected_failure_cases",
            persona_id=persona.persona_id,
            title="Server Error - API Response",
            priority="High",
            description="Test behavior when server returns error",
            preconditions=["API endpoint is available"],
            test_steps=[
                TestStep(1, "Make API request", "Request is sent"),
                TestStep(2, "Simulate server error (500)", "Error response is received"),
                TestStep(3, "Verify error handling", "Error message is shown"),
                TestStep(4, "Verify user feedback", "Appropriate feedback is given"),
            ],
            test_data={"status_code": 500},
            expected_result="Server error is handled gracefully",
            acceptance_criteria=["Error message shown", "User informed", "No crash"],
            related_requirements=["REQ-RESILIENCE-002"],
            related_backlog_items=["BL-016"],
            tags=["failure-case", "server-error", "api"],
            estimated_duration=15,
        ))
        
        return tests
    
    def save_test_suite(self, suite: TestSuite, output_dir: str):
        """Save test suite to YAML file"""
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        file_path = output_path / f"suite_{suite.suite_id}.yaml"
        with open(file_path, 'w') as f:
            f.write(suite.to_yaml())
    
    def load_test_suite(self, input_path: str) -> TestSuite:
        """Load test suite from YAML file"""
        with open(input_path, 'r') as f:
            data = yaml.safe_load(f)
        
        # Reconstruct TestSuite object
        suite = TestSuite(
            suite_id=data['suite_id'],
            persona_id=data['persona_id'],
            persona_name=data['persona_name'],
            generated_at=data['generated_at'],
        )
        
        # Reconstruct test cases
        for test_data in data['test_cases']:
            steps = [TestStep(**step) for step in test_data['test_steps']]
            test_data['test_steps'] = steps
            suite.test_cases.append(TestCase(**test_data))
        
        return suite


def main():
    """Main function for testing the test suite generator"""
    from persona_generator import PersonaGenerator
    
    # Create a sample persona
    persona_gen = PersonaGenerator(seed=42)
    personas = persona_gen.generate_personas(5)
    persona = personas[0]
    
    # Create test suite generator
    config = {
        'features': [],
        'test_types': TestSuiteGenerator.TEST_TYPES,
    }
    generator = TestSuiteGenerator(config)
    
    # Generate test suite
    print(f"Generating test suite for {persona.name} ({persona.persona_id})...")
    suite = generator.generate_test_suite(persona)
    print(f"Generated {len(suite.test_cases)} test cases")
    
    # Print statistics
    print("\nTest Suite Statistics:")
    for test_type in TestSuiteGenerator.TEST_TYPES:
        count = len(suite.get_tests_by_type(test_type))
        if count > 0:
            print(f"  {test_type}: {count}")
    
    # Save test suite
    print("\nSaving test suite to test_master/test_suites/...")
    generator.save_test_suite(suite, "test_master/test_suites")
    print("Test suite saved successfully!")


if __name__ == "__main__":
    main()
