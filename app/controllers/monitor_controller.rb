
class MonitorController < ApplicationController
	before_filter :initialize_monitor_dashboard_tabs, :only => [:index]
	before_filter :initialize_monitor_exceptions_tabs, :only => [:exceptions, :exception]
  before_filter :require_admin
  
  def index
    @exceptions_count = LoggedException.count
  end
  
  def exceptions
    results = LoggedException.all(:limit => MAX_BEVERAGE_RESULTS, :order => 'created_at DESC')
    @exceptions = page_beverage_results(results)
  end
  
  def exception
    @exception = LoggedException.find(params[:id])
  end
  
end