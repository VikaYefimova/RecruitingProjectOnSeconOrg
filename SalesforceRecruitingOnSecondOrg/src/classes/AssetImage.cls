global class AssetImage {
    public ContentVersion contentData {get;set;} 
    public String contentBody {get;set;} 
    
    public AssetImage(ContentVersion cv, String body){ 
    this.contentData = cv;
    this.contentBody = body;
    }
}