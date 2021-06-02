@isTest
public class TestCustAddDel {
    @isTest static void testCustAddition(){
    	Customers__c custAdd = new Customers__c(Name='Steven Peter',First_Name__c='Steven', 
                                    Last_Name__c='Peter', Stage__c='Open', Customer_Price__c=120000);
        Test.startTest();
        Database.SaveResult custSave = Database.insert(custAdd,true);
        Test.stopTest();
        System.assert(custSave.isSuccess());

        List<String> emailContent = Triggers_Demo.sendEmail('vvskg1123@gmail.com', 'New Customer Added', 
                           'Customer! '+custAdd.Name+' is added to our project and the current stage is '+custAdd.Stage__c+ '" stage');
        System.assertEquals('vvskg1123@gmail.com', emailContent[0]);
        System.assertEquals('New Customer Added', emailContent[1]);
        System.assertEquals('Customer! '+custAdd.Name+' is added to our project and the current stage is '+custAdd.Stage__c+ '" stage',
                             emailContent[2]);
    }
    
    @isTest static void testCustDeletion(){
    	Customers__c custAdd = new Customers__c(Name='Steven Peter',First_Name__c='Steven', 
                                    Last_Name__c='Peter', Stage__c='Open', Customer_Price__c=120000);
        insert custAdd;
		
        Test.startTest();
        Database.DeleteResult custResult = Database.delete(custAdd, true);
        Test.stopTest();

		System.assert(custResult.isSuccess()); 
        List<String> emailContent = Triggers_Demo.sendEmail('vvskg1123@gmail.com', 'Customer Deleted', 
                           'Customer! '+custAdd.Name+' is removed from our list and who is in "'+custAdd.Stage__c+ '" stage');
        System.assertEquals('vvskg1123@gmail.com', emailContent[0]);
        System.assertEquals('Customer Deleted', emailContent[1]);
        System.assertEquals('Customer! '+custAdd.Name+' is removed from our list and who is in "'+custAdd.Stage__c+ '" stage',
                             emailContent[2]);
    }
    
    @isTest static void testPropertyUpdate(){
        Apartment__c Apt = new Apartment__c(Name = 'Lake View Apartments', 
                                            Total_SqFt_of_the_Building__c=30000, Total_No_Of_Units__c=20);
    	insert Apt;
        Property__c custProp = new Property__c(Apartment_Name__c=Apt.Id, Property_ID__c='DD212', 
                              Name='LakeView Flat',Unit_Type__c='2Bed 2Bath',Status__c='Available');
        insert custProp;
		
        Customers__c cust = new Customers__c(Name='Steven Peter',First_Name__c='Steven', 
                                   Last_Name__c='Peter', Stage__c='Open', Property_Interested_In__c = custProp.id, Customer_Price__c=120000);
        insert cust;
        // System.debug(cust.Property_Interested_In__r.Property_ID__c);
        List<Customers__c> custData = [select Stage__c from Customers__c where Name='Steven Peter'];

        Test.startTest();
        try {
        	for(Customers__c c : custData){
            	c.Stage__c='Closed';
		   		system.debug('updated customer status '+c.Stage__c);    
        	}
        } catch (Exception e){
            system.debug(e.getMessage());
        }

        Database.SaveResult[] custUpdate = Database.update(custData);
        for(Database.SaveResult ds : custUpdate){
            System.assert(ds.isSuccess());
        }

        custProp = [select Name, Status__c, Unit_Type__c from Property__c where name = 'LakeView Flat' ];
        System.debug('property status '+custProp.Status__c);
        System.assertEquals('Sold', custProp.Status__c);
        Test.stopTest();              
    }
	//customer property status updating to other than Closed
    @isTest static void testPropertyUpdate1(){
        Apartment__c Apt = new Apartment__c(Name = 'Lake View Apartments', 
                                            Total_SqFt_of_the_Building__c=30000, Total_No_Of_Units__c=20);
    	insert Apt;
        Property__c custProp = new Property__c(Apartment_Name__c=Apt.Id, Property_ID__c='DD212', 
                              Name='LakeView Flat',Unit_Type__c='2Bed 2Bath',Status__c='Available');
        insert custProp;
		
        Customers__c cust = new Customers__c(Name='Steven Peter',First_Name__c='Steven', 
                                   Last_Name__c='Peter', Stage__c='Open', Property_Interested_In__c = custProp.id, Customer_Price__c=120000);
        insert cust;

        List<Customers__c> custData = [select Stage__c from Customers__c where Name='Steven Peter'];

        Test.startTest();
        try {
        	for(Customers__c c : custData){
            	c.Stage__c='In Progress';
		   		system.debug('updated customer status '+c.Stage__c);    
        	}
        } catch (Exception e){
            system.debug(e.getMessage());
        }
        
        Database.SaveResult[] custUpdate = Database.update(custData);
        for(Database.SaveResult ds : custUpdate){
            System.assert(ds.isSuccess());
        }
        custProp = [select Name, Status__c, Unit_Type__c from Property__c where name = 'LakeView Flat' ];
        //System.debug('property status '+custProp.Status__c);
        System.assertEquals('Available', custProp.Status__c);
        Test.stopTest();              
    }
}