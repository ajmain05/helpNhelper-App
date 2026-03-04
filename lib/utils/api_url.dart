const baseUrlProd = "https://helpnhelper.com/api/v1/"; // XSERVER ip
const baseUrlLocal = "http://localhost:8000/api/v1/";

final baseUrl = baseUrlProd;
final loginApi = "${baseUrl}login";
final getCampaignCategoryApi = "${baseUrl}campaign/category";
final getCampaignApi = "${baseUrl}campaign";
final getHistoryApi = "${baseUrl}user-history";
final getSuccessStoryApi = "${baseUrl}success-story";
final signUpApi = "${baseUrl}user-request?type=";
final signInApi = "${baseUrl}sign-in";
final otpApi = "${baseUrl}get-signin-otp";
final countryApi = "${baseUrl}country";
final divisionApi = "${baseUrl}division?country_id=";
final districtApi = "${baseUrl}district?division_id=";
final upazilaApi = "${baseUrl}upazila?district_id=";
final seekerApplyFundApiaApi = "${baseUrl}fund-request";
final logOutApi = "${baseUrl}sign-out";
final getTransactionMethodsApi = "${baseUrl}banks";
final getTransactionApi = "${baseUrl}transactions";
final updateTransactionStatusApi =
    "${baseUrl}transactions/update-receive-status/";
final uploadDocApi = "${baseUrl}volunteer-investigate-document/";
final donationApi = "${baseUrl}donation";
final getTeamMembersApi = "${baseUrl}team-member";
final getStatsApi = "${baseUrl}stats";
final getFaqApi = "${baseUrl}faq";
