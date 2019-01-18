@isTest
public class TestEndpointForGetImage {
	@isTest
    public static void testGetImage(){
        CandidateCV__c testCandidate = new CandidateCV__c(Name = 'TestCV TestCandidate', Email__c = 'testcvemail@mail.com');
        insert testCandidate;
        JobAdvertisementPageForSiteController test = new JobAdvertisementPageForSiteController();
        Blob file = Blob.valueOf('Image for uploaded in test');
        ContentVersion testImage = test.uploadCandidatesImage(file, testCandidate.Name, testCandidate.id);
        ContentVersion candidateImage = [select id, Title,  VersionData, Candidate_Number__c from ContentVersion];
        AssetImage testObject = new AssetImage(candidateImage, EncodingUtil.base64Encode(candidateImage.VersionData));
        List<AssetImage> expectedList = new List<AssetImage>();
        expectedList.add(testObject);
        RestRequest request = new RestRequest();
        request.requestURI = 'https://eu16.salesforce.com/services/apexrest/getImages/0';
        request.httpMethod = 'GET';
        RestContext.request = request;
        List<AssetImage> testList = RestResourceForGetImage.getImages();
        system.assertEquals(expectedList[0].contentBody, testList[0].contentBody);
        system.assertEquals(expectedList[0].contentData.Title, testList[0].contentData.Title);
        system.assertEquals(expectedList[0].contentData.Candidate_Number__c, testList[0].contentData.Candidate_Number__c);
    }
}