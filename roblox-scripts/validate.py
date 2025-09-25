#!/usr/bin/env python3
"""
Simple validation script for Roblox Lua scripts.
Checks for common syntax issues, proper structure, and best practices.
"""

import os
import re
from pathlib import Path

def validate_lua_script(filepath):
    """Validate a Lua script for common issues."""
    with open(filepath, 'r') as f:
        content = f.read()
    
    issues = []
    
    # Check for balanced parentheses, brackets, and braces
    parens = content.count('(') - content.count(')')
    brackets = content.count('[') - content.count(']')
    braces = content.count('{') - content.count('}')
    
    if parens != 0:
        issues.append(f"Unbalanced parentheses: {parens}")
    if brackets != 0:
        issues.append(f"Unbalanced brackets: {brackets}")
    if braces != 0:
        issues.append(f"Unbalanced braces: {braces}")
    
    # Check for common Lua/Roblox patterns
    if 'game:GetService(' in content:
        print(f"✓ Uses proper service access pattern")
    
    if 'pcall(' in content:
        print(f"✓ Uses error handling with pcall")
    
    if 'warn(' in content:
        print(f"✓ Includes warning messages")
    
    # Check for proper string concatenation
    if '..' in content:
        print(f"✓ Uses Lua string concatenation")
    
    # Check for proper comments
    if content.startswith('--[['):
        print(f"✓ Has proper script header documentation")
    
    return issues

def main():
    script_dir = Path(__file__).parent / 'src'
    
    print("Validating Roblox Lua scripts...")
    print("=" * 40)
    
    lua_files = list(script_dir.glob('*.lua'))
    
    if not lua_files:
        print("No .lua files found in src directory")
        return
    
    for lua_file in lua_files:
        print(f"\nValidating {lua_file.name}:")
        print("-" * 20)
        
        issues = validate_lua_script(lua_file)
        
        if issues:
            print("❌ Issues found:")
            for issue in issues:
                print(f"  - {issue}")
        else:
            print("✅ No syntax issues detected")
    
    print(f"\nValidation complete. Checked {len(lua_files)} files.")

if __name__ == "__main__":
    main()