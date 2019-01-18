@restResource(urlMapping='/getImages/*')
global with sharing class RestResourceForGetImage {
	@httpGet
    global static List<AssetImage> getImages() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Integer listOffsetSize  = Integer.valueOf(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        Integer listLimit = 65;
        Integer offset =  listOffsetSize/listLimit;
        system.debug('offset: ' + offset);
    	List<ContentDocumentLink> docId= [select id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId in (select id from CandidateCV__c where LastModifiedDate = YESTERDAY) limit 10 offset :listOffsetSize ];
        if(Test.isRunningTest()){
            docId = [select id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId in (select id from CandidateCV__c) limit 10 offset :listOffsetSize ];
        }
		system.debug('docs' + docId);
        Set<Id> documentId = new Set<Id>();
        for(ContentDocumentLink doc: docId){
            documentId.add(doc.ContentDocumentId);
        }
        List<ContentVersion> cv = [select id, Title,  VersionData, Candidate_Number__c from ContentVersion where ContentDocumentId in: documentId AND IsLatest = true];
		system.debug('con ver: ' + cv);
        List<AssetImage> lsReturnResults = new List<AssetImage>(); 
        for (ContentVersion cv1: cv) { 
            lsReturnResults.add(new AssetImage(cv1, EncodingUtil.base64Encode(cv1.VersionData))); 
        }
        return lsReturnResults; 
    }
}