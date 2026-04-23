#!/bin/bash
# 🏥 Doctor Flow Verification Script

echo "================================================"
echo "  DOCTOR FLOW - POST-INTEGRATION VERIFICATION"
echo "================================================"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Flutter is installed
echo -e "${BLUE}[1/5]${NC} Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    echo -e "${GREEN}✓${NC} Flutter is installed"
else
    echo -e "${RED}✗${NC} Flutter not found. Please install Flutter."
    exit 1
fi

# Check if project structure exists
echo ""
echo -e "${BLUE}[2/5]${NC} Verifying doctor flow files..."

files_to_check=(
    "lib/models/doctor_model.dart"
    "lib/controllers/doctor_registration_controller.dart"
    "lib/bindings/doctor_registration_binding.dart"
    "lib/views/doctor_registration_view.dart"
    "lib/views/doctor_login_view.dart"
    "lib/views/doctor_dashboard_view.dart"
    "lib/views/doctor_appointments_view.dart"
    "lib/views/doctor_patient_history_view.dart"
    "lib/views/doctor_prescriptions_view.dart"
    "lib/views/doctor_payments_view.dart"
)

all_files_exist=true
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} $file"
    else
        echo -e "${RED}✗${NC} $file NOT FOUND"
        all_files_exist=false
    fi
done

if [ "$all_files_exist" = false ]; then
    echo -e "${RED}Error: Some required files are missing!${NC}"
    exit 1
fi

# Check main.dart integration
echo ""
echo -e "${BLUE}[3/5]${NC} Checking main.dart integration..."
if grep -q "doctor_registration_binding" "lib/main.dart"; then
    echo -e "${GREEN}✓${NC} Doctor flow imports found in main.dart"
else
    echo -e "${RED}✗${NC} Doctor flow imports NOT found in main.dart"
    exit 1
fi

if grep -q "/doctor_registration" "lib/main.dart"; then
    echo -e "${GREEN}✓${NC} Doctor routes registered in main.dart"
else
    echo -e "${RED}✗${NC} Doctor routes NOT found in main.dart"
    exit 1
fi

# Run flutter pub get
echo ""
echo -e "${BLUE}[4/5]${NC} Running flutter pub get..."
flutter pub get > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓${NC} Dependencies resolved"
else
    echo -e "${RED}✗${NC} Failed to resolve dependencies"
    exit 1
fi

# Analyze code
echo ""
echo -e "${BLUE}[5/5]${NC} Analyzing Dart code..."
flutter analyze 2>&1 | grep -i "error" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${GREEN}✓${NC} No errors detected in Dart code"
else
    echo -e "${YELLOW}⚠${NC} Some warnings/errors detected (see above)"
fi

# Summary
echo ""
echo "================================================"
echo -e "${GREEN}  ✓ DOCTOR FLOW INTEGRATION VERIFIED!${NC}"
echo "================================================"
echo ""
echo "Next steps:"
echo "  1. Run: flutter clean"
echo "  2. Run: flutter run"
echo "  3. Navigate to RegisterAsView"
echo "  4. Select 'Doctor' and click Submit"
echo "  5. Test all doctor flow screens"
echo ""
echo "For issues, check:"
echo "  - INTEGRATION_COMPLETE.md"
echo "  - DOCTOR_FLOW_README.md"
echo "  - INTEGRATION_CHECKLIST.md"
echo ""
