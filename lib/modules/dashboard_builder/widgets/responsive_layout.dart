import 'package:flutter/material.dart';
import '../models/dashboard_models.dart';

class ResponsiveDashboardLayout extends StatelessWidget {
  final DashboardModel dashboard;
  final List<Widget> children;
  final Widget? sidebar;
  final bool isEditMode;

  const ResponsiveDashboardLayout({
    Key? key,
    required this.dashboard,
    required this.children,
    this.sidebar,
    this.isEditMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        
        // Determine layout type based on screen size
        if (screenWidth < 600) {
          return _buildMobileLayout(context, screenWidth, screenHeight);
        } else if (screenWidth < 1200) {
          return _buildTabletLayout(context, screenWidth, screenHeight);
        } else {
          return _buildDesktopLayout(context, screenWidth, screenHeight);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, double screenWidth, double screenHeight) {
    // Mobile: Stack layout with fixed canvas size
    final canvasScale = _getMobileCanvasScale(screenWidth);
    
    return Scaffold(
      body: Column(
        children: [
          // Mobile header
          _buildMobileHeader(context),
          
          // Canvas area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Transform.scale(
                  scale: canvasScale,
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: dashboard.canvas.width,
                    height: dashboard.canvas.height,
                    child: Stack(
                      children: children,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Mobile bottom toolbar
          if (isEditMode)
            _buildMobileToolbar(context),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, double screenWidth, double screenHeight) {
    // Tablet: Side-by-side or stacked layout
    final showSidebar = sidebar != null && screenWidth > 800;
    
    return Scaffold(
      body: Row(
        children: [
          // Sidebar (if screen is wide enough)
          if (showSidebar)
            Container(
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: sidebar,
            ),
          
          // Main content
          Expanded(
            child: Column(
              children: [
                // Tablet header
                _buildTabletHeader(context),
                
                // Canvas area
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: InteractiveViewer(
                        panEnabled: true,
                        scaleEnabled: true,
                        minScale: 0.5,
                        maxScale: 2.0,
                        child: SizedBox(
                          width: dashboard.canvas.width,
                          height: dashboard.canvas.height,
                          child: Stack(
                            children: children,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, double screenWidth, double screenHeight) {
    // Desktop: Full-featured layout with sidebar and toolbar
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar
          if (sidebar != null)
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: sidebar,
            ),
          
          // Main content area
          Expanded(
            child: Column(
              children: [
                // Top toolbar
                _buildDesktopToolbar(context),
                
                // Canvas area with scrollbars
                Expanded(
                  child: Container(
                    color: Colors.grey.shade100,
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.all(32),
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SizedBox(
                                width: dashboard.canvas.width,
                                height: dashboard.canvas.height,
                                child: Stack(
                                  children: children,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (dashboard.description != null)
                  Text(
                    dashboard.description!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMobileMenu(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard.name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (dashboard.description != null)
                  Text(
                    dashboard.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _handleRefresh(context),
            tooltip: 'Refresh Dashboard',
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _handleShare(context),
            tooltip: 'Share Dashboard',
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          
          const SizedBox(width: 16),
          
          // Dashboard info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dashboard.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (dashboard.description != null)
                  Text(
                    dashboard.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(width: 24),
          
          // Actions
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => _handleRefresh(context),
                tooltip: 'Refresh Dashboard',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () => _handleShare(context),
                tooltip: 'Share Dashboard',
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _handleSettings(context),
                tooltip: 'Dashboard Settings',
              ),
              if (isEditMode) ...[
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: () => _handleSave(context),
                  tooltip: 'Save Dashboard',
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileToolbar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Widget'),
              onPressed: () => _handleAddWidget(context),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _handleSave(context),
            tooltip: 'Save',
          ),
        ],
      ),
    );
  }

  double _getMobileCanvasScale(double screenWidth) {
    // Calculate scale to fit canvas on mobile screen
    final padding = 32.0; // Total horizontal padding
    final availableWidth = screenWidth - padding;
    
    if (availableWidth >= dashboard.canvas.width) {
      return 1.0;
    }
    
    return availableWidth / dashboard.canvas.width;
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Refresh'),
              onTap: () {
                Navigator.pop(context);
                _handleRefresh(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _handleShare(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _handleSettings(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleRefresh(BuildContext context) {
    // Handle refresh action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard refreshed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleShare(BuildContext context) {
    // Handle share action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share dialog would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSettings(BuildContext context) {
    // Handle settings action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings dialog would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleSave(BuildContext context) {
    // Handle save action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard saved'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleAddWidget(BuildContext context) {
    // Handle add widget action
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Add widget dialog would open here'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? largeDesktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        if (width >= 1600 && largeDesktop != null) {
          return largeDesktop!;
        } else if (width >= 1200 && desktop != null) {
          return desktop!;
        } else if (width >= 600 && tablet != null) {
          return tablet!;
        } else {
          return mobile;
        }
      },
    );
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;
  final T? largeDesktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
    this.largeDesktop,
  });

  T getValue(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width >= 1600 && largeDesktop != null) {
      return largeDesktop!;
    } else if (width >= 1200 && desktop != null) {
      return desktop!;
    } else if (width >= 600 && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

extension ResponsiveExtension on BuildContext {
  T responsiveValue<T>(ResponsiveValue<T> value) {
    return value.getValue(this);
  }
  
  bool get isMobile => MediaQuery.of(this).size.width < 600;
  bool get isTablet => MediaQuery.of(this).size.width >= 600 && MediaQuery.of(this).size.width < 1200;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;
  bool get isLargeDesktop => MediaQuery.of(this).size.width >= 1600;
}