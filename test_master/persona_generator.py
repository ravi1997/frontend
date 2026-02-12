"""
Test Master - Persona Generator
Generates diverse personas for automated testing
"""

import random
import yaml
from typing import List, Dict, Any
from dataclasses import dataclass, asdict
from pathlib import Path
import json


@dataclass
class Persona:
    """Represents a test persona with diverse characteristics"""
    persona_id: str
    name: str
    age_group: str
    technology_experience: str
    behavior: str
    testing_style: str
    interaction_style: str
    role: str
    agent_profile: str
    special_focus: str
    language: str
    accessibility_needs: List[str]
    viewport: Dict[str, int]
    browser_preferences: List[str]
    typing_speed: str
    error_prone: bool
    multi_tasking: bool
    
    def to_dict(self) -> Dict[str, Any]:
        return asdict(self)
    
    def to_yaml(self) -> str:
        return yaml.dump(self.to_dict(), default_flow_style=False, sort_keys=False)


class PersonaGenerator:
    """Generates diverse personas for testing"""
    
    # Persona dimension values
    AGE_GROUPS = ["18-24", "25-34", "35-44", "45-54", "55+"]
    TECH_EXPERIENCE = ["Novice", "Intermediate", "Expert", "Accessibility User"]
    BEHAVIORS = ["Focused", "Distracted", "Multi-tasking", "Exploratory"]
    TESTING_STYLES = ["Fast", "Detailed", "Emotional", "Technical", "Security-Focused"]
    INTERACTION_STYLES = ["Form-Heavy", "Navigation-Heavy", "Visual", "Textual", "Mobile-First"]
    ROLES = ["Casual User", "Power User", "Administrator", "Developer", "QA Tester"]
    AGENT_PROFILES = ["Skeptical", "Vandal", "Reporter", "Balanced"]
    SPECIAL_FOCUSES = ["Accessibility", "Performance", "Security", "UX", "General"]
    LANGUAGES = ["English", "Spanish", "French", "German", "Japanese", "Chinese", "Arabic"]
    ACCESSIBILITY_NEEDS_OPTIONS = [
        [],  # No accessibility needs
        ["Screen Reader"],
        ["Keyboard-Only"],
        ["High Contrast"],
        ["Magnification"],
        ["Voice Control"],
        ["Screen Reader", "Keyboard-Only"],
    ]
    VIEWPORTS = [
        {"width": 1920, "height": 1080},  # Desktop
        {"width": 1366, "height": 768},   # Laptop
        {"width": 768, "height": 1024},   # Tablet
        {"width": 375, "height": 667},    # Mobile
        {"width": 414, "height": 896},    # Large Mobile
    ]
    BROWSER_PREFERENCES = [
        ["chromium"],
        ["firefox"],
        ["webkit"],
        ["chromium", "firefox"],
        ["chromium", "webkit"],
    ]
    TYPING_SPEEDS = ["Slow", "Normal", "Fast", "Instant"]
    
    # Predefined names for personas
    NAMES = [
        "Alex Thompson", "Maria Garcia", "James Wilson", "Sarah Chen", "David Kim",
        "Emma Rodriguez", "Michael Brown", "Lisa Anderson", "Robert Taylor", "Jennifer Martinez",
        "William Lee", "Amanda White", "Christopher Davis", "Jessica Johnson", "Daniel Smith",
        "Emily Clark", "Matthew Lewis", "Ashley Walker", "Andrew Hall", "Stephanie Young",
        "Joshua King", "Michelle Wright", "Ryan Scott", "Nicole Green", "Kevin Adams",
        "Rachel Hill", "Brandon Moore", "Samantha Jackson", "Justin White", "Elizabeth Harris"
    ]
    
    def __init__(self, seed: int = None):
        """Initialize persona generator with optional seed for reproducibility"""
        if seed is not None:
            random.seed(seed)
        self.personas: List[Persona] = []
    
    def generate_personas(self, count: int = 25) -> List[Persona]:
        """Generate specified number of diverse personas"""
        personas = []
        
        # Ensure diversity by tracking used combinations
        used_combinations = set()
        
        for i in range(count):
            persona = self._generate_persona(i + 1, used_combinations)
            personas.append(persona)
            used_combinations.add(self._get_combination_key(persona))
        
        self.personas = personas
        return personas
    
    def _generate_persona(self, index: int, used_combinations: set) -> Persona:
        """Generate a single persona with diverse characteristics"""
        max_attempts = 100
        attempts = 0
        
        while attempts < max_attempts:
            # Generate random characteristics
            age_group = random.choice(self.AGE_GROUPS)
            tech_experience = random.choice(self.TECH_EXPERIENCE)
            behavior = random.choice(self.BEHAVIORS)
            testing_style = random.choice(self.TESTING_STYLES)
            interaction_style = random.choice(self.INTERACTION_STYLES)
            role = random.choice(self.ROLES)
            agent_profile = random.choice(self.AGENT_PROFILES)
            special_focus = random.choice(self.SPECIAL_FOCUSES)
            language = random.choice(self.LANGUAGES)
            accessibility_needs = random.choice(self.ACCESSIBILITY_NEEDS_OPTIONS)
            viewport = random.choice(self.VIEWPORTS)
            browser_preferences = random.choice(self.BROWSER_PREFERENCES)
            typing_speed = random.choice(self.TYPING_SPEEDS)
            error_prone = behavior in ["Distracted", "Multi-tasking"]
            multi_tasking = behavior == "Multi-tasking"
            
            # Adjust characteristics based on technology experience
            if tech_experience == "Novice":
                typing_speed = random.choice(["Slow", "Normal"])
                error_prone = True
            elif tech_experience == "Expert":
                typing_speed = random.choice(["Fast", "Instant"])
                error_prone = False
            
            # Adjust for accessibility users
            if tech_experience == "Accessibility User":
                accessibility_needs = random.choice([
                    ["Screen Reader"],
                    ["Keyboard-Only"],
                    ["High Contrast"],
                    ["Magnification"],
                    ["Voice Control"],
                ])
                special_focus = "Accessibility"
            
            # Adjust for security-focused testing style
            if testing_style == "Security-Focused":
                special_focus = "Security"
                agent_profile = "Skeptical"
            
            # Create combination key
            combination_key = self._get_combination_key_from_values(
                age_group, tech_experience, behavior, testing_style,
                interaction_style, role, agent_profile, special_focus
            )
            
            # Check if this combination is already used
            if combination_key not in used_combinations:
                # Create persona
                persona = Persona(
                    persona_id=f"P-{index:03d}",
                    name=random.choice(self.NAMES),
                    age_group=age_group,
                    technology_experience=tech_experience,
                    behavior=behavior,
                    testing_style=testing_style,
                    interaction_style=interaction_style,
                    role=role,
                    agent_profile=agent_profile,
                    special_focus=special_focus,
                    language=language,
                    accessibility_needs=accessibility_needs,
                    viewport=viewport,
                    browser_preferences=browser_preferences,
                    typing_speed=typing_speed,
                    error_prone=error_prone,
                    multi_tasking=multi_tasking,
                )
                return persona
            
            attempts += 1
        
        # If we couldn't find a unique combination, generate a random one
        return Persona(
            persona_id=f"P-{index:03d}",
            name=random.choice(self.NAMES),
            age_group=random.choice(self.AGE_GROUPS),
            technology_experience=random.choice(self.TECH_EXPERIENCE),
            behavior=random.choice(self.BEHAVIORS),
            testing_style=random.choice(self.TESTING_STYLES),
            interaction_style=random.choice(self.INTERACTION_STYLES),
            role=random.choice(self.ROLES),
            agent_profile=random.choice(self.AGENT_PROFILES),
            special_focus=random.choice(self.SPECIAL_FOCUSES),
            language=random.choice(self.LANGUAGES),
            accessibility_needs=random.choice(self.ACCESSIBILITY_NEEDS_OPTIONS),
            viewport=random.choice(self.VIEWPORTS),
            browser_preferences=random.choice(self.BROWSER_PREFERENCES),
            typing_speed=random.choice(self.TYPING_SPEEDS),
            error_prone=random.choice([True, False]),
            multi_tasking=random.choice([True, False]),
        )
    
    def _get_combination_key(self, persona: Persona) -> str:
        """Get a unique key for a persona combination"""
        return self._get_combination_key_from_values(
            persona.age_group, persona.technology_experience, persona.behavior,
            persona.testing_style, persona.interaction_style, persona.role,
            persona.agent_profile, persona.special_focus
        )
    
    def _get_combination_key_from_values(self, age_group: str, tech_experience: str,
                                         behavior: str, testing_style: str,
                                         interaction_style: str, role: str,
                                         agent_profile: str, special_focus: str) -> str:
        """Get a unique key from persona values"""
        return f"{age_group}_{tech_experience}_{behavior}_{testing_style}_{interaction_style}_{role}_{agent_profile}_{special_focus}"
    
    def select_diverse_personas(self, count: int = 5) -> List[Persona]:
        """Select diverse personas ensuring representation of different dimensions"""
        if len(self.personas) < count:
            raise ValueError(f"Not enough personas generated. Need {count}, have {len(self.personas)}")
        
        selected = []
        used_dimensions = {
            'tech_experience': set(),
            'behavior': set(),
            'testing_style': set(),
            'role': set(),
            'agent_profile': set(),
            'special_focus': set(),
        }
        
        # Ensure at least one accessibility user
        accessibility_personas = [p for p in self.personas if p.technology_experience == "Accessibility User"]
        if accessibility_personas:
            selected.append(accessibility_personas[0])
            self._update_used_dimensions(selected[0], used_dimensions)
        
        # Ensure at least one security-focused persona
        security_personas = [p for p in self.personas if p.testing_style == "Security-Focused"]
        if security_personas:
            selected.append(security_personas[0])
            self._update_used_dimensions(selected[-1], used_dimensions)
        
        # Ensure at least one skeptical persona
        skeptical_personas = [p for p in self.personas if p.agent_profile == "Skeptical"]
        if skeptical_personas:
            selected.append(skeptical_personas[0])
            self._update_used_dimensions(selected[-1], used_dimensions)
        
        # Fill remaining slots with diverse personas
        remaining = count - len(selected)
        candidates = [p for p in self.personas if p not in selected]
        
        for _ in range(remaining):
            if not candidates:
                break
            
            # Score candidates based on diversity
            best_candidate = None
            best_score = -1
            
            for candidate in candidates:
                score = self._calculate_diversity_score(candidate, used_dimensions)
                if score > best_score:
                    best_score = score
                    best_candidate = candidate
            
            if best_candidate:
                selected.append(best_candidate)
                self._update_used_dimensions(best_candidate, used_dimensions)
                candidates.remove(best_candidate)
        
        return selected
    
    def _update_used_dimensions(self, persona: Persona, used_dimensions: Dict[str, set]):
        """Update used dimensions set with persona characteristics"""
        used_dimensions['tech_experience'].add(persona.technology_experience)
        used_dimensions['behavior'].add(persona.behavior)
        used_dimensions['testing_style'].add(persona.testing_style)
        used_dimensions['role'].add(persona.role)
        used_dimensions['agent_profile'].add(persona.agent_profile)
        used_dimensions['special_focus'].add(persona.special_focus)
    
    def _calculate_diversity_score(self, persona: Persona, used_dimensions: Dict[str, set]) -> int:
        """Calculate diversity score for a persona based on used dimensions"""
        score = 0
        
        if persona.technology_experience not in used_dimensions['tech_experience']:
            score += 1
        if persona.behavior not in used_dimensions['behavior']:
            score += 1
        if persona.testing_style not in used_dimensions['testing_style']:
            score += 1
        if persona.role not in used_dimensions['role']:
            score += 1
        if persona.agent_profile not in used_dimensions['agent_profile']:
            score += 1
        if persona.special_focus not in used_dimensions['special_focus']:
            score += 1
        
        return score
    
    def save_personas(self, output_dir: str):
        """Save all personas to YAML files"""
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        for persona in self.personas:
            file_path = output_path / f"persona_{persona.persona_id}.yaml"
            with open(file_path, 'w') as f:
                f.write(persona.to_yaml())
    
    def load_personas(self, input_dir: str) -> List[Persona]:
        """Load personas from YAML files"""
        input_path = Path(input_dir)
        personas = []
        
        for yaml_file in sorted(input_path.glob("persona_*.yaml")):
            with open(yaml_file, 'r') as f:
                data = yaml.safe_load(f)
                personas.append(Persona(**data))
        
        self.personas = personas
        return personas
    
    def get_persona_by_id(self, persona_id: str) -> Persona:
        """Get a persona by ID"""
        for persona in self.personas:
            if persona.persona_id == persona_id:
                return persona
        raise ValueError(f"Persona {persona_id} not found")
    
    def get_personas_by_characteristic(self, **kwargs) -> List[Persona]:
        """Get personas matching specific characteristics"""
        results = self.personas
        
        for key, value in kwargs.items():
            results = [p for p in results if getattr(p, key, None) == value]
        
        return results


def main():
    """Main function for testing the persona generator"""
    generator = PersonaGenerator(seed=42)
    
    # Generate 25 personas
    print("Generating 25 diverse personas...")
    personas = generator.generate_personas(25)
    print(f"Generated {len(personas)} personas")
    
    # Select 5 diverse personas
    print("\nSelecting 5 diverse personas...")
    selected = generator.select_diverse_personas(5)
    print(f"Selected {len(selected)} personas:")
    for persona in selected:
        print(f"  - {persona.persona_id}: {persona.name} ({persona.technology_experience}, {persona.behavior}, {persona.testing_style})")
    
    # Save personas
    print("\nSaving personas to test_master/personas/...")
    generator.save_personas("test_master/personas")
    print("Personas saved successfully!")
    
    # Print statistics
    print("\nPersona Statistics:")
    print(f"  Total Personas: {len(personas)}")
    print(f"  Technology Experience: {set(p.technology_experience for p in personas)}")
    print(f"  Behaviors: {set(p.behavior for p in personas)}")
    print(f"  Testing Styles: {set(p.testing_style for p in personas)}")
    print(f"  Roles: {set(p.role for p in personas)}")
    print(f"  Agent Profiles: {set(p.agent_profile for p in personas)}")
    print(f"  Special Focuses: {set(p.special_focus for p in personas)}")
    print(f"  Accessibility Users: {sum(1 for p in personas if p.technology_experience == 'Accessibility User')}")
    print(f"  Security-Focused: {sum(1 for p in personas if p.testing_style == 'Security-Focused')}")


if __name__ == "__main__":
    main()
