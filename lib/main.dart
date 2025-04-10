import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart'; // Import for date formatting

// --- Entry Point ---
void main() {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Set preferred orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    // Run the Login App first
    runApp(LoginApp());
  });
}

// --- Login App Components ---

// Root widget for the initial login flow
class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login', // Title for the login part
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Optional: Use Material 3 styling
      ),
      debugShowCheckedModeBanner: false, // Hide debug banner
      home: LoginPage(), // Start with the LoginPage
    );
  }
}

// Login Page Widget
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Handles form submission and navigation
  Future<void> _submitForm() async {
    // Validate the form first
    // Dummy validation: accept user@example.com / password
    bool isValid = false;
    if (_formKey.currentState?.validate() ?? false) {
      // Check dummy credentials AFTER basic validation passes
      if (_emailController.text == 'user@example.com' &&
          _passwordController.text == 'password') {
        isValid = true;
      } else if (_emailController.text != 'user@example.com') {
        // Show specific error if email is wrong (and password might be right/wrong)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect email. Try "user@example.com"')),
        );
      } else {
        // Show specific error if password is wrong (email must be right here)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Incorrect password. Try "password"')),
        );
      }
    }

    if (isValid) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network request (authentication)
      await Future.delayed(Duration(seconds: 1)); // Reduced delay

      setState(() {
        _isLoading = false;
      });

      // Navigate to the Loan Manager App after successful login
      // Replacing the current route stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoanManagerApp()), // Navigate here
      );
    } else if (!(_formKey.currentState?.validate() ?? false)) {
      // Optional: Show a snackbar if basic validation (empty, format) fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fix the errors in the form')),
      );
    }
    // No else needed here, specific error snackbars shown above for credential mismatch
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Removed AppBar for a cleaner login look, handled by body content
      body: SafeArea(
        // Ensure content avoids notches/status bars
        child: Center(
          // Center the content vertically
          child: SingleChildScrollView(
            // Allow scrolling on small screens
            padding: const EdgeInsets.all(24.0), // Increased padding
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Stretch buttons/fields
                children: [
                  // App Logo/Title
                  Icon(Icons.account_balance_wallet_outlined,
                      size: 64, color: Theme.of(context).primaryColor),
                  SizedBox(height: 16),
                  Text(
                    'Loan Manager Pro',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                  ),
                  SizedBox(height: 40),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'you@example.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Basic email format check
                      if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value)) {
                        return 'Please enter a valid email format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(vertical: 16), // Taller button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      // Use primary color from theme
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white, // Text color
                    ),
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? SizedBox(
                            // Constrain indicator size
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 3, color: Colors.white),
                          )
                        : Text('LOGIN',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      // Placeholder for forgot password action
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Forgot Password functionality not implemented.')),
                      );
                    },
                    child: Text('Forgot Password?'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// --- Loan Manager App Components (Previously MyApp) ---

// Data Model for Loans
class Loan {
  final String name;
  final double amount;
  final double remaining;
  final DateTime dueDate;
  final double interestRate;
  final String type; // e.g., 'Mortgage', 'Vehicle', 'Personal'

  Loan({
    required this.name,
    required this.amount,
    required this.remaining,
    required this.dueDate,
    required this.interestRate,
    required this.type,
  });
}

// --- Main App Widget ---
class LoanManagerApp extends StatefulWidget {
  @override
  _LoanManagerAppState createState() => _LoanManagerAppState();
}

class _LoanManagerAppState extends State<LoanManagerApp> {
  bool _isDarkMode = false; // State for theme mode
  int _currentIndex = 0; // State for bottom navigation index

  // Sample Loan Data (Remains here as it's app-level data)
  final List<Loan> _loans = [
    Loan(
      name: 'Home Mortgage',
      amount: 250000,
      remaining: 175000,
      dueDate: DateTime(2025, 11, 15),
      interestRate: 3.5,
      type: 'Mortgage',
    ),
    Loan(
      name: 'Car Loan',
      amount: 35000,
      remaining: 12500,
      dueDate: DateTime(2025, 8, 20),
      interestRate: 5.2,
      type: 'Vehicle',
    ),
    Loan(
      name: 'Student Loan',
      amount: 50000,
      remaining: 45000,
      dueDate: DateTime(2026, 1, 30),
      interestRate: 4.1,
      type: 'Personal',
    ),
    Loan(
      name: 'Vacation Fund',
      amount: 5000,
      remaining: 850.50,
      dueDate: DateTime(2025, 5, 1),
      interestRate: 8.0,
      type: 'Personal',
    ),
  ];

  // List of screens corresponding to the bottom navigation items
  late final List<Widget> _screens; // Initialize in initState

  @override
  void initState() {
    super.initState();
    // Initialize the screens list with widget instances
    // Pass necessary data and callbacks
    _screens = [
      DashboardScreen(loans: _loans), // Pass loans data
      RecommendationsScreen(), // No specific data needed for this simple version
      CalculationsScreen(loans: _loans), // Pass loans data
      SettingsScreen(
        // Pass current theme state and callback
        isDarkMode: _isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
        onLogout: _handleLogout, // Pass logout handler
      ),
    ];
  }

  // Handles the logout action initiated from SettingsScreen
  void _handleLogout() {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Confirm Logout'),
            content: Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(), // Close dialog
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close dialog
                  // Navigate back to LoginApp, replacing the stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginApp()),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                },
                child: Text('Logout',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error)),
              ),
            ],
          );
        });
  }

  // --- Themes (Remain in the main app state) ---
  ThemeData _lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[100],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed, // Keep fixed type
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.blue,
        linearTrackColor: Colors.grey[300],
      ),
      listTileTheme: ListTileThemeData(iconColor: Colors.blue[700]),
      iconTheme: IconThemeData(color: Colors.blue[700]),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blueGrey,
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.grey[900],
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[850],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: Colors.cyanAccent[100],
        unselectedItemColor: Colors.grey[500],
        backgroundColor: Colors.grey[850],
        type: BottomNavigationBarType.fixed, // Keep fixed type
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: Colors.cyanAccent[100],
        linearTrackColor: Colors.grey[700],
      ),
      listTileTheme: ListTileThemeData(iconColor: Colors.cyanAccent[100]),
      iconTheme: IconThemeData(color: Colors.cyanAccent[100]),
    );
  }

  // --- Main Build Method ---
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Manager Pro',
      theme: _lightTheme(),
      darkTheme: _darkTheme(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // Body dynamically changes based on the selected tab
        body: IndexedStack(
          // Keep state of inactive screens
          index: _currentIndex,
          children: _screens,
        ),

        // Bottom Navigation Bar
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          // Theme handles selected/unselected colors and background
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              activeIcon: Icon(Icons.lightbulb),
              label: 'Offers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate_outlined),
              activeIcon: Icon(Icons.calculate),
              label: 'Calculate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEW: Dashboard Screen Widget ---
class DashboardScreen extends StatelessWidget {
  final List<Loan> loans;

  const DashboardScreen({Key? key, required this.loans}) : super(key: key);

  // --- Helper Widgets (Moved Here) ---

  // Builds a single loan card widget
  Widget _buildLoanCard(Loan loan, BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    IconData loanIcon;
    Color progressColor;

    switch (loan.type) {
      case 'Mortgage':
        loanIcon = Icons.home_filled;
        progressColor = Colors.blueAccent;
        break;
      case 'Vehicle':
        loanIcon = Icons.directions_car_filled;
        progressColor = Colors.greenAccent;
        break;
      case 'Personal':
        loanIcon = Icons.person_outline;
        progressColor = Colors.orangeAccent;
        break;
      default:
        loanIcon = Icons.attach_money;
        progressColor = Colors.purpleAccent;
    }

    double progressValue = (loan.amount <= 0)
        ? 0.0
        : (1 - (loan.remaining / loan.amount)).clamp(0.0, 1.0);
    String formattedDueDate = DateFormat('MM/dd/yyyy').format(loan.dueDate);

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? theme.colorScheme.primaryContainer.withOpacity(0.5)
                    : theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(loanIcon,
                  color: theme.colorScheme.onPrimaryContainer, size: 28),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(loan.name,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor:
                        theme.progressIndicatorTheme.linearTrackColor,
                    valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${(loan.amount - loan.remaining).toStringAsFixed(0)} paid of \$${loan.amount.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Remaining: \$${loan.remaining.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Due:', style: theme.textTheme.labelSmall),
                  Text(formattedDueDate,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  SizedBox(height: 6),
                  Text('Rate:', style: theme.textTheme.labelSmall),
                  Text('${loan.interestRate.toStringAsFixed(1)}% APR',
                      style: TextStyle(
                          color: isDark
                              ? Colors.cyanAccent[100]
                              : theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Builds a single summary item
  Widget _buildSummaryItem(String title, String value, BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
            textAlign: TextAlign.center),
        SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Calculate totals safely
    double totalAmount =
        loans.fold<double>(0, (sum, loan) => sum + loan.amount);
    double totalRemaining =
        loans.fold<double>(0, (sum, loan) => sum + loan.remaining);
    double avgRate = loans.isEmpty
        ? 0.0
        : loans.fold<double>(0, (sum, loan) => sum + loan.interestRate) /
            loans.length;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('Dashboard'),
          expandedHeight: 180,
          pinned: true,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            // titlePadding: EdgeInsetsDirectional.only(start: 72, bottom: 16), // Adjust if needed
            stretchModes: [StretchMode.zoomBackground, StretchMode.fadeTitle],
            background: Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(bottom: 20, left: 12, right: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            theme.colorScheme.primaryContainer,
                            Colors.grey[850]!
                          ]
                        : [
                            theme.colorScheme.primary,
                            theme.colorScheme.primaryContainer
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: _buildSummaryItem('Total Loaned',
                              '\$${totalAmount.toStringAsFixed(0)}', context)),
                      Expanded(
                          child: _buildSummaryItem(
                              'Total Owed',
                              '\$${totalRemaining.toStringAsFixed(0)}',
                              context)),
                      Expanded(
                          child: _buildSummaryItem('Avg Rate',
                              '${avgRate.toStringAsFixed(1)}%', context)),
                    ],
                  ),
                )),
          ),
          backgroundColor:
              isDark ? Colors.grey[850] : theme.colorScheme.primary,
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
            child: Text('Your Loans', style: theme.textTheme.titleLarge),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _buildLoanCard(loans[index], context),
            childCount: loans.length,
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20), // Bottom padding
        ),
      ],
    );
  }
}

// --- NEW: Recommendations Screen Widget ---
class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({Key? key}) : super(key: key);

  // Builds a recommendation card widget
  // (Can remain here or be moved to its own file if complex)
  Widget _buildRecommendationCard(BuildContext context, int index) {
    final theme = Theme.of(context);
    final titles = [
      'Refinance Offer',
      'Debt Consolidation',
      'New Credit Card',
      'Investment Plan'
    ];
    final details = [
      'Lower your car payment!\nEst. 4.5% APR',
      'Combine debts into one payment.\nEst. 7.0% APR',
      'Earn rewards points!\n1.5% Cashback',
      'Grow your savings.\nExplore options'
    ];
    final icons = [
      Icons.lightbulb_outline,
      Icons.mediation_outlined,
      Icons.credit_card,
      Icons.trending_up
    ];
    final buttonTexts = [
      'Learn More',
      'Explore Options',
      'Apply Now',
      'View Plans'
    ];
    final colors = [
      Colors.yellow[600],
      Colors.purple[300],
      Colors.orange[400],
      Colors.green[400]
    ];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Container(
        width: 220,
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icons[index % icons.length],
                size: 36, color: colors[index % colors.length]),
            SizedBox(height: 12),
            Text(titles[index % titles.length],
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            SizedBox(height: 8),
            Text(details[index % details.length],
                textAlign: TextAlign.center, style: theme.textTheme.bodyMedium),
            Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        'Showing details for: ${titles[index % titles.length]}')));
              },
              child: Text(buttonTexts[index % buttonTexts.length]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Recommendations'),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 0),
                child: Text('Personalized Offers',
                    style: theme.textTheme.titleMedium),
              ),
              Container(
                height: 250, // Give the horizontal list a fixed height
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) =>
                      _buildRecommendationCard(context, index),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
                child:
                    Text('Financial Tools', style: theme.textTheme.titleMedium),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    'More recommendations or tools can go here.',
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(height: 20), // Bottom padding
            ],
          ),
        ));
  }
}

// --- NEW: Settings Screen Widget ---
class SettingsScreen extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged; // Callback for theme switch
  final VoidCallback onLogout; // Callback for logout button

  const SettingsScreen({
    Key? key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            children: [
              Card(
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text('Dark Mode'),
                      value: isDarkMode,
                      onChanged: onThemeChanged, // Use the callback directly
                      secondary: Icon(isDarkMode
                          ? Icons.brightness_7_outlined
                          : Icons.brightness_4_outlined),
                    ),
                    Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Account Settings'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Account Settings Tapped')));
                      },
                    ),
                    Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.notifications_none),
                      title: Text('Notifications'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Notifications Tapped')));
                      },
                    ),
                    Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.security_outlined),
                      title: Text('Security'),
                      trailing: Icon(Icons.chevron_right),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Security Tapped')));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Card(
                child: ListTile(
                  leading: Icon(Icons.help_outline,
                      color: theme.colorScheme.secondary),
                  title: Text('Help & Support'),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Help Tapped')));
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('About Loan Manager Pro'),
                  onTap: () {
                    showAboutDialog(
                        context: context,
                        applicationName: 'Loan Manager Pro',
                        applicationVersion: '1.1.0',
                        applicationLegalese: '© 2025 Your Company Name',
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: Text('Manage your loans effectively.'))
                        ]);
                  },
                ),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.logout),
                  label: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  onPressed: onLogout, // Use the logout callback
                ),
              ),
              SizedBox(height: 20), // Bottom padding
            ],
          ),
        ));
  }
}

// --- Calculations Screen Widget (Existing - No major changes needed here) ---
class CalculationsScreen extends StatelessWidget {
  final List<Loan> loans; // Receive the list of loans

  const CalculationsScreen({Key? key, required this.loans}) : super(key: key);

  // Helper function to create styled list tiles for calculations
  Widget _buildCalculationTile(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      Color? iconColor}) {
    final theme = Theme.of(context);
    final effectiveIconColor =
        iconColor ?? theme.listTileTheme.iconColor ?? theme.colorScheme.primary;

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      child: ListTile(
        leading: Icon(icon, color: effectiveIconColor, size: 28),
        title: Text(title, style: theme.textTheme.titleMedium),
        trailing: Text(
          value,
          style:
              theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final numberFormat =
        NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 2);
    final numberFormatCompact =
        NumberFormat.currency(locale: 'en_US', symbol: '\$', decimalDigits: 0);

    // --- Calculations ---
    final int loanCount = loans.length;
    final double totalRemaining =
        loans.fold<double>(0, (sum, loan) => sum + loan.remaining);
    final double totalAmount =
        loans.fold<double>(0, (sum, loan) => sum + loan.amount);
    final double totalPaid = totalAmount - totalRemaining;
    final double averageInterestRate = loanCount == 0
        ? 0.0
        : loans.fold<double>(0, (sum, loan) => sum + loan.interestRate) /
            loanCount;
    final double overallProgress =
        totalAmount <= 0 ? 0.0 : (totalPaid / totalAmount).clamp(0.0, 1.0);
    Loan? highestOwedLoan = loans.isNotEmpty
        ? loans.reduce(
            (curr, next) => curr.remaining > next.remaining ? curr : next)
        : null;
    Loan? nearestDueDateLoan = loans.isNotEmpty
        ? loans.reduce(
            (curr, next) => (curr.dueDate.isBefore(next.dueDate) ? curr : next))
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Loan Analysis & Calculations'),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Text('Overall Summary', style: theme.textTheme.titleLarge),
            SizedBox(height: 16),
            _buildCalculationTile(context,
                icon: Icons.pin_outlined,
                title: 'Number of Loans',
                value: loanCount.toString(),
                iconColor: Colors.blueGrey),
            _buildCalculationTile(context,
                icon: Icons.payments_outlined,
                title: 'Total Original Loan Amount',
                value: numberFormatCompact.format(totalAmount),
                iconColor: Colors.green),
            _buildCalculationTile(context,
                icon: Icons.account_balance_wallet_outlined,
                title: 'Total Remaining Balance',
                value: numberFormat.format(totalRemaining),
                iconColor: Colors.orange),
            _buildCalculationTile(context,
                icon: Icons.check_circle_outline,
                title: 'Total Amount Paid Off',
                value: numberFormatCompact.format(totalPaid),
                iconColor: Colors.lightGreen),
            _buildCalculationTile(context,
                icon: Icons.trending_up,
                title: 'Average Interest Rate (APR)',
                value: '${averageInterestRate.toStringAsFixed(1)}%',
                iconColor: Colors.redAccent),
            Card(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.hourglass_top_outlined,
                          color: Colors.purpleAccent, size: 28),
                      SizedBox(width: 16),
                      Text('Overall Repayment Progress',
                          style: theme.textTheme.titleMedium)
                    ]),
                    SizedBox(height: 12),
                    LinearProgressIndicator(
                        value: overallProgress,
                        minHeight: 10,
                        backgroundColor:
                            theme.progressIndicatorTheme.linearTrackColor,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                        borderRadius: BorderRadius.circular(5)),
                    SizedBox(height: 8),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                            '${(overallProgress * 100).toStringAsFixed(1)}% Paid Off',
                            style: theme.textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text('Loan Specifics', style: theme.textTheme.titleLarge),
            SizedBox(height: 16),
            if (highestOwedLoan != null)
              _buildCalculationTile(context,
                  icon: Icons.arrow_upward,
                  title: 'Highest Balance Loan',
                  value:
                      '${highestOwedLoan.name} (${numberFormat.format(highestOwedLoan.remaining)})',
                  iconColor: Colors.deepOrange),
            if (nearestDueDateLoan != null)
              _buildCalculationTile(context,
                  icon: Icons.event_available,
                  title: 'Nearest Due Date',
                  value:
                      '${nearestDueDateLoan.name} (${DateFormat('MM/dd/yy').format(nearestDueDateLoan.dueDate)})',
                  iconColor: Colors.blueAccent),
            SizedBox(height: 24),
            Text('Calculation Tools', style: theme.textTheme.titleLarge),
            SizedBox(height: 16),
            Card(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              child: ListTile(
                leading:
                    Icon(Icons.add_chart, color: theme.colorScheme.secondary),
                title: Text('Amortization Calculator'),
                subtitle: Text('Coming Soon!'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          'Amortization Calculator not yet implemented.')));
                },
              ),
            ),
            Card(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
              child: ListTile(
                leading: Icon(Icons.compare_arrows,
                    color: theme.colorScheme.secondary),
                title: Text('Loan Comparison Tool'),
                subtitle: Text('Coming Soon!'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text('Loan Comparison Tool not yet implemented.')));
                },
              ),
            ),
            SizedBox(height: 20), // Bottom padding
          ],
        ),
      ),
    );
  }
}
