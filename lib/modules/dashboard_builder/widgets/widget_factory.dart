import 'package:flutter/material.dart';
import 'dashboard_widget.dart';
import 'chart_widgets.dart';
import 'basic_widgets.dart';
import '../models/dashboard_models.dart';
import '../pages/dashboard_builder_page.dart';

class DashboardWidgetFactory {
  static Widget createWidget({
    required dynamic model,
    Function(dynamic)? onChanged,
    Function(dynamic)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) {
    // Extract the actual DashboardWidgetModel from wrapper if needed
    final actualModel = model is DashboardWidgetModelWrapper ? model.widget : model;
    
    // Create wrapper functions if needed
    Function(DashboardWidgetModel)? wrappedOnChanged;
    if (onChanged != null) {
      wrappedOnChanged = (DashboardWidgetModel updatedModel) {
        if (model is DashboardWidgetModelWrapper) {
          final wrappedUpdated = DashboardWidgetModelWrapper(widget: updatedModel);
          onChanged(wrappedUpdated);
        } else {
          onChanged(updatedModel);
        }
      };
    }
    
    Function(DashboardWidgetModel)? wrappedOnPositionChanged;
    if (onPositionChanged != null) {
      wrappedOnPositionChanged = (DashboardWidgetModel updatedModel) {
        if (model is DashboardWidgetModelWrapper) {
          final wrappedUpdated = DashboardWidgetModelWrapper(widget: updatedModel);
          onPositionChanged(wrappedUpdated);
        } else {
          onPositionChanged(updatedModel);
        }
      };
    }
    switch (actualModel.widgetType) {
      case 'kpi_card':
        return KpiCardWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'bar_chart':
        return BarChartWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'line_chart':
        return LineChartWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'pie_chart':
        return PieChartWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'data_table':
        return DataTableWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'text':
        return TextWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'image':
        return ImageWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      case 'filter':
        return FilterWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
      
      default:
        return _UnknownWidget(
          model: actualModel,
          onChanged: wrappedOnChanged,
          onPositionChanged: wrappedOnPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );
    }
  }
}

class _UnknownWidget extends DashboardWidget {
  const _UnknownWidget({
    Key? key,
    required DashboardWidgetModel model,
    Function(DashboardWidgetModel)? onChanged,
    Function(DashboardWidgetModel)? onPositionChanged,
    bool isSelected = false,
    bool isEditable = true,
  }) : super(
          key: key,
          model: model,
          onChanged: onChanged,
          onPositionChanged: onPositionChanged,
          isSelected: isSelected,
          isEditable: isEditable,
        );

  @override
  _UnknownWidgetState createState() => _UnknownWidgetState();
}

class _UnknownWidgetState extends ConsumerState<_UnknownWidget> {
  @override
  Widget buildWidget(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.help_outline,
            size: 48,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            'Unknown Widget Type',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.model.widgetType,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}