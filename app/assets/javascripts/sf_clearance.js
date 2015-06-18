ko.observableArray.fn.distinct = function(prop) {
    var target = this;
    console.log('this', this)
    console.log(target.index)
    target.index = target.index || {};
    target.index[prop] = ko.observable({});    
    ko.computed(function() {
        //rebuild index
        var propIndex = {};
        
        ko.utils.arrayForEach(target(), function(item) {
            var key = ko.utils.unwrapObservable(item[prop]);
            if (key) {
                propIndex[key] = propIndex[key] || [];
                propIndex[key].push(item);            
            }
        });   
        
        target.index[prop](propIndex);
    });

    return target;
};    

ko.observableArray.fn.source = function(prop) {
    var target = this;
    target.index = {};
    target.index[prop] = ko.observable({});    
    
    ko.computed(function() {
        //rebuild index
        var propIndex = {};
        
        ko.utils.arrayForEach(target(), function(item) {
            var key = ko.utils.unwrapObservable(item[prop]);
            if (key) {
                propIndex[key] = propIndex[key] || [];
                propIndex[key].push(item);            
            }
        });   
        
        target.index[prop](propIndex);
    });

    return target;
};    
var ItemAdderModel = function() {
    var self = this;
    self.potentialId = ko.observable("")
    self.newItem = ko.observable("").publishOn("newItem");
    
    self.addItem = function (){
        var model = self;
        var url = "/items/" + self.potentialId();
        var data = {
            id: self.potentialId(),
            manage_event: 'clearance'
        };
        $.ajax({
            url: url,
            data: JSON.stringify(data),
            success:function(d){
                model.newItem(d);   
            },
            method: "PUT",
            contentType: "application/json; charset=utf-8"
        });  
        model.potentialId(""); 
    }
}


var RecentItemListModel = function(items){
    var self = this;
    self.allItems = ko.observableArray(items);
    self.batchToRemove = ko.observable("").subscribeTo("removeBatch", function(batch) {
      var model = self;
      var itemsFromUndoBatch = [];
      itemsFromUndoBatch = _.where(model.allItems(), {clearance_batch_id: batch.id})
      _.each(itemsFromUndoBatch, function(i){  
          console.log("i", i)
          model.allItems.remove(i)
          console.log("items removed", model.allItems().length)
      });
    });
    self.newItem = ko.observable("").subscribeTo("newItem", function(newValue) {
      var plainJS = ko.toJS(newValue);
      if(typeof(plainJS) == 'object'){
          self.allItems.unshift(plainJS);
      }
    });
    self.itemToRemove = ko.observable("");
    self.undoClearance = function(i){
        var model = self;
        var url = "/items/" + i.id;
        self.itemToRemove(i);
        var data = {
            id: i.id,
            manage_event: 'clearance'
        };
        $.ajax({
            url: url,
            data: JSON.stringify(data),
            success:function(d){
                model.allItems.remove(model.itemToRemove());   
                model.itemToRemove("");

            },
            method: "PUT",
            contentType: "application/json; charset=utf-8"
        });   
        
    }
    self.removeItem = function(i){
        var model = self;
        $.ajax({
            url: self.itemToRemove(i),
            method: 'DELETE',
            success: function(e,i,d) {
                model.allItems.remove(
                    model.itemToRemove()
                );
                model.itemToRemove("");
            },
            contentType: 'JSON'
        })
    }
}

var ItemIndexModel = function(paged_items, all_items){
    var self = this;

    self.fullItemSet = ko.observableArray(all_items).distinct('clearance_batch_id').distinct('status');   
    self.allItems = ko.observableArray(paged_items).distinct('clearance_batch_id').distinct('status'); 
    self.groups = ko.observableArray();
    self.groupBy = ko.observable();
    self.groupOptions = ['Status', 'Clearance Batch ID'];
    self.showAll = ko.computed(function(){
        return typeof(self.groupBy()) == 'undefined'
    })
    self.getGroupedItems = function(group){
        
    }
    self.changeGroup = function(m,e){
      if(self.groupBy() == 'Status'){ 
          self.groups(self.statuses());
          self.allItems(self.fullItemSet());
      }
      else if(self.groupBy() == 'Clearance Batch ID'){ 
          self.groups(self.batches())
          self.allItems(self.fullItemSet());
      }

    }
    self.batches = ko.computed(function(){
        var batchList = _.pluck(self.allItems(), "clearance_batch_id")
        return _.uniq(batchList);
    });
    self.statuses = ko.computed(function(){
        var statusList = _.pluck(self.allItems(), "status")
        return _.uniq(statusList);
    });
   
    self.groupByStatus = function(){
      var group = _.groupBy(self.allItems(), function(i){
          return i.status;
      });
      console.log("group",group)
      console.log("group",ko.toJSON(group))
      plainjson = JSON.stringify(group)
      
      self.groupedResults(ko.toJS(plainjson))
    };
    self.groupByBatch = function() {
      var group = _.groupBy(self.allItems(), function(i){
          return i.clearance_batch_id;
      });
    }
     
};

var BatchListModel = function(batches) {
    var self = this;
    self.allBatches = ko.observableArray(batches);
    self.batchToAdd = ko.observable("");
    
    self.batchToRemove = ko.observable("").publishOn("removeBatch");
    self.addBatch = function () {
        if ((self.batchToAdd() != "") && (self.allBatches.indexOf(self.batchToAdd()) < 0)) // Prevent blanks and duplicates
            self.allBatches.push(self.batchToAdd());
        this.batchToAdd(""); // Clear the text box
    };
    
    self.undoClearance = function(d) {
        var batchToRemove = self.batchToRemove(d);
        var allBatches = self.allBatches();
        var model = self; 
        $.ajax({
            url: self.batchToRemove().url,
            method: "DELETE",
            success: function(e,i,d){
                model.allBatches.remove(
                    model.batchToRemove()
                )
                model.batchToRemove("");
            },
            contentType: 'JSON'
        });
        

    }   
}
