# Wage Calculator

A Flutter mobile app that calculates wages for bulk items (like sacks of rice) based on quantity, weight, and wage rate.

## Features

- **Multiple Items**: Add/remove multiple items with the '+' and '-' buttons
- **Dynamic Calculations**: Real-time calculations as you input data
- **Input Fields**: 
  - Quantity (number of sacks/items)
  - Weight per item (in kg)
  - Wage rate (per 100 kg)
- **Results Display**:
  - Total weight of all items (aggregated from all items)
  - Calculated total wage
  - Formula display for reference

## Wage Calculation Formula

```
Total Wage = (Total Weight × Wage Rate) ÷ 100
```

**Example:**
- 5 sacks × 50 kg each = 250 kg total
- Wage rate: 500 per 100 kg
- Wage = (250 × 500) ÷ 100 = **1,250**

## Project Requirements

- Flutter version: 3.41.1
- Dart: 3.11.0

## How to Run

### 1. Install Flutter
Make sure you have Flutter installed. Download it from [flutter.dev](https://flutter.dev)

### 2. Get Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Windows
flutter run -d windows
```

### 4. Build for Release
```bash
# Android APK
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## Project Structure

```
wage_calculator/
├── lib/
│   └── main.dart              # Main app code with all functionality
├── pubspec.yaml               # Flutter project configuration
├── analysis_options.yaml      # Linter rules
├── .gitignore                 # Git ignore file
└── README.md                  # This file
```

## How to Use the App

1. **Add Items**: 
   - Enter quantity and weight for the first item
   - Click **"+ Add Item"** button to add more items

2. **View Individual Totals**:
   - Total weight is automatically calculated and displayed for each item
   - Each item shows: Quantity × Weight = Item Total Weight

3. **View Summary**:
   - The Summary section aggregates all items
   - Shows the combined total weight of all items

4. **Calculate Wage**:
   - Enter the wage rate (per 100 kg) in the summary section
   - The total wage is calculated automatically
   - Formula: (Total Weight × Wage Rate) ÷ 100

5. **Remove Items**:
   - Click the delete/trash icon on any item card to remove it
   - Must keep at least one item

## App Architecture

The app is built with:
- **StatefulWidget**: For reactive state management
- **Material Design 3**: Modern UI components
- **ListView.builder**: Efficient rendering of dynamic item list
- **TextEditingController**: For number input management
- **Real-time Updates**: setState() triggers UI refresh on input changes

## Features in Detail

### Item Management
- Each item is stored in an `Item` class with controllers for quantity and weight
- Automatic calculation of each item's total weight
- Visual card display for each item
- Delete button for easy removal

### Wage Calculation
- Formula applied: `(Total Weight × Wage Rate) ÷ 100`
- Numeric inputs only (quantity, weight, wage rate)
- Real-time calculation updates as user types
- Two decimal places display for precision

### UI/UX
- Clean, organized layout with sections
- Color-coded information (blue for weight, green for wage)
- Input validation with numeric keyboards
- Responsive design that works on different screen sizes

## Notes

- All numeric inputs are optional and default to 0 if not provided
- Wage rate should be entered as the payment per 100 kg
- The app can handle unlimited items (add as many as needed)
- All calculations happen locally on the device

## License

This project is open source.
