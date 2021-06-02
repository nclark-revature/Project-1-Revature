public class contactEmailDup {
    public static void conEmailDup(){
        List<customers__c> cust = new List<Customers__C>();
        String customerId = '';
        for(customers__c c : cust){
            customerId = c.Id;
        }
        List<Property__c> prop = [SELECT id FROM Property__c WHERE 
                        id in (SELECT Property_interested_in__c FROM Customers__c where Stage__c = 'Closed')];
		//System.debug(prop);
        for(Customers__c custClosed : cust){
            if(custClosed.Stage__c=='Closed'){
                for(Property__c propSold : prop){
                    if(propSold.id == custClosed.Property_Interested_In__c){
                        propSold.Status__c = 'Sold';
                    }
                }
            }
        }
    }

//Customer_emailId__c
}

/*
 *     public static void updatePropCustClosed(List<Customers__c> cust){
      //  List<Customers__c> cust = Trigger.new;
        String customerId = '';
        for(customers__c c : cust){
            customerId = c.Id;
        }
        List<Property__c> prop = [SELECT id FROM Property__c WHERE 
                        id in (SELECT Property_interested_in__c FROM Customers__c where ID = :customerId)];
		//System.debug(prop);
        for(Customers__c custClosed : cust){
            if(custClosed.Stage__c=='Closed'){
                for(Property__c propSold : prop){
                    if(propSold.id == custClosed.Property_Interested_In__c){
                        propSold.Status__c = 'Sold';
                    }
                }
            }
        }
        update prop;
    }
*/