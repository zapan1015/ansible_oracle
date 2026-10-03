#!/bin/bash
# ========================================================
# Helper script to test and verify Chapter 2 Inventory
# ========================================================

set -e

echo "=================================================="
echo "1. Testing INI Inventory Graph"
echo "=================================================="
ansible-inventory -i inventory/inventory.ini --graph

echo "=================================================="
echo "2. Testing Host Variables for proddb01"
echo "=================================================="
ansible-inventory -i inventory/inventory.ini --host proddb01

echo "=================================================="
echo "3. Testing Ping for all environments (dev, test, prod)"
echo "=================================================="
ansible dev -i inventory/inventory.ini -m ping
ansible test -i inventory/inventory.ini -m ping
ansible prod -i inventory/inventory.ini -m ping

echo "=================================================="
echo "4. Testing YAML Inventory Graph"
echo "=================================================="
ansible-inventory -i inventory/inventory.yml --graph

echo "=================================================="
echo "Inventory Test Complete! All nodes healthy."
echo "=================================================="
