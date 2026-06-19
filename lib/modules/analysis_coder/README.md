# Analysis Coder Module

## Overview

The Analysis Coder module provides a visual node-based interface for creating and executing data analysis pipelines. It allows users to:

- Create visual analysis graphs by dragging and dropping nodes
- Connect nodes to define data flow
- Configure node properties
- Execute analyses on-demand, reactively, or on a schedule
- Export results in various formats (CSV, Excel, PDF)

## Features

### Node Types

The module includes 25+ built-in node types organized into categories:

#### Data Sources
- **Form Responses**: Load responses from a form
- **CSV Upload**: Upload and parse a CSV file
- **Manual Data Entry**: Inline data table editor
- **Cross Form Join**: Join responses from two forms
- **External API Fetch**: Fetch JSON from an external HTTP endpoint

#### Transforms
- **Filter**: Filter rows by condition
- **Sort**: Sort rows by column(s)
- **Group By**: Group rows + aggregate
- **Join**: Join two datasets on a key
- **Calculate Column**: Add a computed column
- **Pivot**: Pivot table transformation
- **Unpivot**: Reverse pivot
- **Rename Columns**: Rename column headers
- **Select Columns**: Keep/drop specific columns
- **Deduplicate**: Remove duplicate rows
- **Fill Missing**: Fill null/missing values

#### Aggregations
- **Count**: Count rows (with group-by support)
- **Sum**: Sum a numeric column
- **Average**: Average a numeric column
- **Min/Max**: Min and Max values
- **Median**: Median value
- **Percentile**: Nth percentile
- **Frequency**: Frequency distribution
- **Cross Tabulation**: Cross-tab between two categorical columns

#### Outputs
- **Table Output**: Render a data table
- **KPI Value**: Single numeric KPI
- **Bar Chart Data**: Formatted bar chart data
- **Line Chart Data**: Formatted line chart data
- **Pie Chart Data**: Formatted pie chart data
- **Export Node**: Trigger CSV/Excel/PDF export

### Execution Modes

The module supports three execution modes:

1. **On-demand**: Execute manually when requested
2. **Reactive**: Automatically execute when input data changes
3. **Scheduled**: Execute on a cron schedule

### Error Isolation

The analysis engine implements error isolation to ensure that:
- Failing nodes don't stop the entire pipeline
- Errors are contained to individual branches
- Partial results are still available

## Architecture

### Backend

The backend is built with Flask and includes:

- **Analysis Models**: Data models for analyses, nodes, edges, and results
- **Analysis Service**: Business logic for CRUD operations and execution
- **Analysis Engine**: DAG execution engine with node executors
- **Celery Tasks**: Asynchronous execution with error isolation
- **Export Service**: CSV/Excel/PDF generation
- **API Routes**: REST endpoints for all operations

### Frontend

The frontend is built with Flutter and includes:

- **Analysis Coder Screen**: Main screen with node graph canvas
- **Node Palette**: Available nodes organized by category
- **Graph Widget**: Interactive canvas for building analysis graphs
- **Node Widget**: Individual node rendering and interaction
- **Edge Widget**: Connection rendering between nodes
- **Configuration Dialog**: Node property configuration
- **Analysis Service**: API communication layer

## Usage

### Creating an Analysis

1. Navigate to a project and click "Analysis Boards"
2. Click "Analysis Coder" button to open the visual editor
3. Drag nodes from the palette to the canvas
4. Connect nodes by dragging from output ports to input ports
5. Configure node properties by right-clicking or double-clicking
6. Save the analysis
7. Execute the analysis to see results

### Example Analysis Pipeline

A simple analysis pipeline might look like:

1. **Form Responses** → Load form data
2. **Filter** → Filter responses based on criteria
3. **Group By** → Group by a column and count
4. **Bar Chart Data** → Format for visualization
5. **Table Output** → Display results

## API Endpoints

### Analysis Operations

- `GET /api/v1/projects/{projectId}/analyses` - List analyses
- `POST /api/v1/projects/{projectId}/analyses` - Create analysis
- `GET /api/v1/projects/{projectId}/analyses/{analysisId}` - Get analysis
- `PUT /api/v1/projects/{projectId}/analyses/{analysisId}` - Update analysis
- `DELETE /api/v1/projects/{projectId}/analyses/{analysisId}` - Delete analysis

### Execution

- `POST /api/v1/projects/{projectId}/analyses/{analysisId}/execute` - Execute analysis
- `GET /api/v1/projects/{projectId}/analyses/{analysisId}/runs` - List runs
- `GET /api/v1/projects/{projectId}/analyses/{analysisId}/runs/{runId}` - Get run
- `GET /api/v1/projects/{projectId}/analyses/{analysisId}/results` - Get results

### Exports

- `POST /api/v1/projects/{projectId}/analyses/{analysisId}/exports` - Create export
- `GET /api/v1/projects/{projectId}/analyses/{analysisId}/exports/{exportId}` - Get export
- `GET /api/v1/projects/{projectId}/analyses/{analysisId}/exports/{exportId}/download` - Download export

## Development

### Adding New Node Types

To add a new node type:

1. **Backend**: Create a new node executor in `analysis_engine.py`
2. **Models**: Add the node definition to the node library
3. **Frontend**: Add the node to the palette and configuration UI
4. **Testing**: Test the node in isolation and in pipelines

### Extending the Module

The module is designed to be extensible:

- Add custom node types via plugins
- Extend the execution engine for new capabilities
- Add new export formats
- Customize the UI theme and components

## Dependencies

### Backend

- Flask
- Celery
- MongoDB
- Redis
- NetworkX (for DAG operations)

### Frontend

- Flutter
- Riverpod (state management)
- GoRouter (navigation)
- Material Design (UI components)

## Testing

Run tests with:

```bash
# Backend tests
cd docker/apps/form-backend
pytest tests/

# Frontend tests
cd frontend
flutter test test/analysis_coder_test.dart
```

## Future Enhancements

- [ ] Real-time collaboration
- [ ] Version control for analyses
- [ ] More visualization options
- [ ] Advanced node types (ML, statistical analysis)
- [ ] Performance optimization for large datasets
- [ ] Import/export analysis configurations