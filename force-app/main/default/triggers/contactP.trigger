trigger contactP on Contact (before insert) {
    public static void conEmailDup(){
    	List<Contact> con = new List<Contact>([select email from contact where email!=null]);
    	for(Contact c : con){
      	  System.debug('Print email '+c.email);
        }
    }  
}