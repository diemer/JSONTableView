class NewTableController < UITableViewController
  def viewDidLoad
    @listitems = {}
    @listindicies = []
    view.dataSource = view.delegate = self
   
    createListItems
  end
  
  def viewWillAppear(animated)
    navigationItem.title = 'WuTang via JSON'
    refresh = UIBarButtonItem.alloc.initWithTitle("Refresh", style:UIBarButtonItemStylePlain, target: self, action: 'refresh')
    navigationItem.rightBarButtonItem = refresh
  end
  
  def createListItems
    url = "https://raw.github.com/gist/2785014/176642422bea65fe0fc9920fd45df7fd29477451/wutang.json"
  
    Dispatch::Queue.concurrent.async do
      error_ptr = Pointer.new(:object)
      data = NSData.alloc.initWithContentsOfURL(NSURL.URLWithString(url), options:NSDataReadingUncached, error:error_ptr)
      unless data
        presentError error_ptr[0]
        return
      end
      json = NSJSONSerialization.JSONObjectWithData(data, options:0, error:error_ptr)
      unless json
        presentError error_ptr[0]
        return
      end
    
      items = {}
      indicies = []
      json.each do |dict|
        if !items.has_key? dict['lastname'][0]
          items[dict['lastname'][0]] = {:header => dict['lastname'][0], :values => []}
        end
        items[dict['lastname'][0]][:values] << ListItem.new(dict)
        
        if !indicies.include? dict['lastname'][0]
          indicies << dict['lastname'][0]
        end
      end
    
      Dispatch::Queue.main.sync {loadListItems(items, indicies.sort)}
    
    end
  end

  def loadListItems(items, indicies)
    @listitems.clear
    @listitems = items
    
    @listindicies.clear
    @listindicies = indicies
    
    view.reloadData
  end
  
  def presentError(error)
    $stderr.puts error.description
  end
  
  def numberOfSectionsInTableView(tableView)
    @listindicies.size
  end
  
  def sectionIndexTitlesForTableView(tableView)
    @listindicies
  end
  
  
  def tableView(tableView, sectionForSectionIndexTitle:title, atIndex:index)
    index
  end
  
  def tableView(tableView, titleForHeaderInSection:section)
      @listindicies[section]
  end
  
  def tableView(tableView, numberOfRowsInSection:section) 
    if @listitems.size == 0
      0
    else
      @listitems[@listindicies[section]][:values].size
    end
  end
  
  CELLID = 'CellIdentifier'
  def tableView(tableView, cellForRowAtIndexPath:indexPath)
  	cell = tableView.dequeueReusableCellWithIdentifier(CELLID) || begin
      cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:CELLID)
      cell.accessoryType = UITableViewCellAccessoryNone
      cell
    end
    
    item = @listitems[@listindicies[indexPath.section]][:values][indexPath.row]
    cell.textLabel.text = item.title
  	cell
  end
  
  def refresh
    createListItems
    NSLog "Button was tapped"
  end
end