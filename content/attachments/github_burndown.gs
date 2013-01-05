/**
 * Heads to github fetches milestone info, and adds rows to spreadsheet
 */
function updateBugCounts() {
  var resp = UrlFetchApp.fetch("https://api.github.com/repos/DramaFever/www/milestones?access_token=XXX");
  var jsonStr = resp.getContentText();
  var milestones = Utilities.jsonParse(jsonStr);
  
  var dataSs = SpreadsheetApp.openById("YYY");
  var sheet = dataSs.getSheetByName('Raw Data');
  for (var i = 0; i < milestones.length; i++) {
    milestone = milestones[i];
    sheet.appendRow([milestone.title, Utilities.formatDate(new Date(), "US/Eastern", "yyyy-MM-dd"), milestone.open_issues, milestone.closed_issues])
  }
}

/**
 * get the full data table (dates and counts) for a all milestones as extracted from the raw data sheet
 */
function getDataTable() {
  var dataSs = SpreadsheetApp.openById("0Ag86SykVA-evdDdIbnR4emhvVGxHYnJKejczWDhMYWc");
  var sheet = dataSs.getSheetByName('Raw Data');
  var cells = sheet.getDataRange().getValues();
  var retval = Charts.newDataTable()
       .addColumn(Charts.ColumnType.STRING, "Milestone")
       .addColumn(Charts.ColumnType.STRING, "Date")
       .addColumn(Charts.ColumnType.NUMBER, "Open")
       .addColumn(Charts.ColumnType.NUMBER, "Closed");
  for (var row = 1; row < cells.length; row++) { // skip header
    retval.addRow([cells[row][0], Utilities.formatDate(cells[row][1], "US/Eastern", "yyyy-MM-dd"), cells[row][2], cells[row][3]]);
  }
  return retval.build();
}


function doGet() {
    var data = getDataTable();
    
    var dataViewDefinition = Charts.newDataViewDefinition()
       .setColumns([1, 2, 3])
       .build();

    var chart = Charts.newAreaChart()
        .setDataViewDefinition(dataViewDefinition)
        .setTitle("Burndown Chart")
        .setStacked()
        .setDimensions(800, 500)
        .build()

    var control = Charts.newCategoryFilter()
      .setFilterColumnLabel("Milestone")
      .setAllowNone(false)
      .setAllowMultiple(false)
      .build();

    var dashboard = Charts.newDashboardPanel()
      .setDataTable(data)
      .bind(control, chart)
      .build();

    var uiApp = UiApp.createApplication().setTitle("GitHub Burndown");

    var panel = uiApp.createHorizontalPanel()
      .setVerticalAlignment(UiApp.VerticalAlignment.MIDDLE)
      .setSpacing(50);

    panel.add(control);
    panel.add(chart);
    dashboard.add(panel);
    uiApp.add(dashboard);
    return uiApp;
}
