import 'dart:async';

import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      "available": "Available",
      "description": "Description",
      "language": "en",
      'title': 'Hello World',
      "signin": "Sign In",
      "signup": "Sign Up",
      "signuppp": "Sign Up",
      "email": "Email",
      "emailvalidator": "invalid email ",
      "emailverification": "Email Verification",
      "confirmemail": "confirm email",
      "password": "Password",
      "passwordvalidator": "invalid password 6+",
      "confirmpassword": "confirm password",
      "confirmpasswordvalidator": "confirmation password do not match",
      "forgetpassword": "forgot password",
      "login": "Login",
      "or": "or",
      "sendmail": "Mail has Been Sent",
      "sendagain": "Send again",
      "contactbymail": "Contact by mail",
      "emailexists": "User exists on the system",
      "emailorpass": "Email or Password not correct",
      "leftTorighit": "rightToLeft",
      "rightToLeft": "leftToRight",
      "linestoday": "Lines today",
      "updatelines": "Update lines",
      "watchalllines": "Choice break and delete",
      "alllines": "All Lines",
      "linescheck": "Scheduled queues can be updated", //checkkk
      "requestcheck": "View all requests can be updated",
      "requestlines": "Lines Requests",
      "requestclients": "Business requests",
      "requestclientsrelly": "Clinets requests",
      "addlinesexplaine": "Set before type and working time", /////בדיקה
      "addlines": "Add Lines",
      "addline": "Add Line",
      "added": "Added",
      "accept": "Accept",
      "reminder": "Reminder",
      "lineisset": "Line is set",
      "kinds": "Type And Duration",
      "update": "Update",
      "minute": "min",
      "timesforline": "time for each line", //בדיקה
      "requests": "Requests",
      "request": "request",
      "home": "Home",
      "lines": "Lines",
      "clients": "Clients",
      "business": "Business",
      "notifications": "Notifications",
      "saved": "Saved",
      "profile": "Profile",
      "search": "Search",
      "searchby": "Search By",
      "images": "Images",
      "settings": "Settings",
      "payments": "Payments",
      "reviewsapp": "Reviews App",
      "followers": "Followers",
      "follow": "follow",
      "following": "Following",
      "fullname": "Full Name",
      "businessname": "Business Name",
      "phone": "Phone",
      "bio": "Bio",
      "gender": "Gender",
      "privateinformation": "Private Information",
      "location": "Location",
      "man": "Man",
      "woman": "Woman",
      "prefernottosay": "Prefer Not to Say",
      "camera": "Camera",
      "gallery": "Gallery",
      "cancel": "Cancel",
      "sharepost": "Share Post ",
      "loading": "Loading",
      "writesometing": "Write Someting",
      "all": "all",
      "su": "Su",
      "mo": "Mo",
      "tu": "Tu",
      "we": "We",
      "th": "Th",
      "fr": "Fr",
      "sa": "Sa",
      "record": "Record",
      "addworker": "Add Worker",
      "version": "Version",
      "aboutus": "About Us",
      "logout": "Logout",
      "regulation": "Regulation",
      "delete": "Delete",
      "break": "Break",
      "newline": "New Line ",
      "createline": "Create Line",
      "createlines": "Create Lines",
      "choice": "choice",
      "deletebreak": "Delete Break ",
      "deleteall": "Delete All",
      "yes": "yes",
      "cosmetics": "Cosmetics",
      "barbershop": "Barbershop",
      "reviews": "Reviews",
      "extra": "Extra",
      "dayswork": "Days Work", //check
      'hairDonation': "Hair Donation",
      "hairWash": "Hair Wash",
      "parking": "Parking",
      "followingyou": "following you",
      "sendrequest": "Send you a request",
      "friendsnow": "and you friends",
      "sendrequestLine": "Send request Line",
      "linedelay": "Delay Line",
      "canceledline": "Canceled line",
      "categories": "Categories",
      "friendrequestmust":
          "friend request You have to enter\n a name and a phone", //check
      "gowaze": " Open in Waze",
      "gogoogle": "Open in Google",
      "call": "call",
      "showprofile": "Show Profile",
      "invitefriend": "Invite Friend",
      "waiting": "waiting",
      "friend": "friends",
      "addreviews": "Add Reviews",
      "changecard": "Change Credit Card",
      "trial": "End Trial",
      "history": "history",
      "offers": "offers",
      "choicekind": "Choice Kind",
      "price": "Price",
      "duration": "Duration from 10min - 120min",
      "apptutorial": "App Tutorial", //
      "date": "Date",
      "time": "Time",
      "sentrequest": "Send Request",
      "invalidnumber": "Invalid Number",
      "invalidname": "Enter name",
      "typeofbusiness": "Type of Business",
      "addlocation": "Add a Location",
      "searchaddress": "Search Address",
      "onemoment": "One moment beginning",
      "betaversion": "Beta Version",
      "noresults": "No results in your area", //
      "deleteaccont": "Delete Account",
      "areusure": "Are you sure",
      "skip": "Skip",
      "businessowner": "Business Owner",
      "client": "Client",
      "trialsearch":
          "חיפוש מספרות וקוסמטיקות\n תוצאות באזורך ברשימה\nמפה והמלצות ",
      "trialwatchbusines": "צפה בעסקים",

      "trialwatchbusiness":
          "צפה בימי עבודה, קטגוריות\nמחירים ותמונות\n ניתן לעקוב ולשלוח בקשת חברות",
      "trialmakeappoint": "קביעת תור",
      "trialmakeappoints":
          "אחרי שבעל העסק אישר אותך\n ניתן לבדוק תורים זמינים\n לשלוח בקשות לתורים\n ואפילו לנווט לבית העסק",
      "trialrequestline": "בקשה לתור",
      "trialrequestlines":
          "בחירת תאריך, שם עובד\n סוג עבודה \n וצפה בתורים זמינים",
      "trialaddworker": "הוספת עובדים",
      "trialaddworkers":
          "הוספת עובדים לעסק שלך\n ניתן ליצור תורים במיוחד עבורם\n ושליטה מלאה על חשבונך",
      "trialaddkind": "הוספת קטגוריית עבודה",
      "trialaddkinds":
          "בחירת סוג עבודה \n לדוגמה: תספורת גבר\n בחר זמן עבודה, מחיר\n וסוג מטבע",
      "trialaddlines":
          "לאחר הוספת עובדים \n וסוג עבודה \n ניתן להוסיף תור תוך בחירה\n בעובד רלוונטי וסוג עבודה",
      "trialallline": "כל התורים והפסקות",
      "trialalllines":
          "צפה בכל התורים שיצרת\n קבע זמן הפסקה \n ניתן לסנן לפי שם עובד",
      "trialrequests": "ניתן לצפות בבקשות \n בחירת  אישור או מחיקה",
      "trialaddlineclient":
          "ניתן להוסיף תור ללקוח\n בחר שם עובד, תור זמין\n שם לקוח וסוג עבודה",
      "trialupdatelines":
          "עדכון באותו יום\n בחר שם עובד וזמן עדכון\nובלחיצה כל הרשימה תקבל עדכון מידי",
      "offline": "OFFLINE",
      "entercode": "Enter sms Code",
      "invalidcode": "Invalid Code or Phone Exists",
      "timechoicenotcorrect": "Time Choice not Correct",
      "choicesamedate": "Choice Same Date. Start and End",
      "edittime": "Edit Time",
      "beginningtime": "Beginning Time",
      "endtime": "End Time",
      "tellus": "Tell us about your problem",
      "choocelineorkind": " Choose a line or other type ",
      "newupdateavailable": "New Update Available",
      "thereisnewversion":
          "There is a newer version of app available please update it now",
      "updatenow": "Update Now",
      "mystore": "My Store",
      "addtostore": "Adding Products to the Store"
    },
    'he': {
      "available": "זמין",
      "description": "תיאור",
      "language": "he",
      'title': 'הולה',
      "signin": "הרשמה",
      "signup": "התחברות",
      "signuppp": "הרשמה",
      "email": "אימייל",
      "emailvalidator": "אימייל שגוי ",
      "emailverification": "נשלח אליך מייל\nלחץ על המייל שקיבלת לאימות",
      "confirmemail": "אימייל מצריך אימות",
      "password": "סיסמא",
      "passwordvalidator": "סיסמא שגויה 6+ ",
      "confirmpassword": "אימות סיסמא",
      "confirmpasswordvalidator": "סיסמא אינה תואמת ",
      "forgetpassword": "שכחת את הסיסמא",
      "login": "התחבר",
      "or": "או",
      "sendmail": "נשלח מייל",
      "sendagain": "שלח שוב",
      "contactbymail": "פניה במייל",
      "emailexists": "משתמש קיים במערכת",
      "emailorpass": "אימייל או סיסמא אינם נכונים",
      "leftTorighit": "leftToRight",
      "rightToLeft": "rightToLeft",
      "linestoday": "תורים היום",
      "updatelines": "עדכון תורים",
      "watchalllines": "ניתן לקבוע הפסקה ומחיקה",
      "alllines": "כל התורים",
      "linescheck": "תורים שנקבעו ניתן לעדכן",
      "requestcheck": "צפה בכל הבקשות ניתן לעדכן",
      "requestlines": "בקשות תורים",
      "requestclients": "בקשות עסקים",
      "requestclientsrelly": "בקשות לקוחות",
      "addlinesexplaine": "הגדר לפי סוג וזמן עבודה",
      "addlines": "הוספת תורים",
      "addline": "הוספת תור",
      "added": "התווסף",
      "accept": "אישור",
      "reminder": "תזכורת",
      "lineisset": "תור נקבע",
      "kinds": "סוגים וזמן",
      "update": "עדכון",
      "minute": "דקות",
      "timesforline": "זמן כל תור",
      "requests": "בקשות",
      "request": "בקשה",
      "home": "בית",
      "lines": "תורים",
      "clients": "לקוחות",
      "business": " עסקים",
      "notifications": "עדכונים",
      "saved": "שמירה",
      "profile": "פרופיל",
      "search": "חיפוש",
      "searchby": "חיפוש לפי",
      "images": "תמונות",
      "settings": "הגדרות",
      "payments": "תשלומים",
      "reviewsapp": "דרג אותנו",
      "followers": "עוקבים",
      "follow": "עקוב",
      "following": "עוקב",
      "fullname": "שם מלא",
      "businessname": "שם העסק",
      "phone": "פלאפון",
      "bio": "ביו",
      "gender": "מין",
      "privateinformation": "פרטים אישיים",
      "location": "מיקום",
      "man": "גבר",
      "woman": "אישה",
      "prefernottosay": "לא מוגדר",
      "camera": "מצלמה",
      "gallery": "גלריה",
      "cancel": "ביטול",
      "sharepost": "פרסם פוסט",
      "loading": "טוען",
      "writesometing": "כתוב משהו",
      "all": "כולם",
      "su": "א",
      "mo": "ב",
      "tu": "ג",
      "we": "ד",
      "th": "ה",
      "fr": "ו",
      "sa": "ז",
      "record": "דוח עבודה",
      "addworker": "הוספת עובד",
      "version": "גרסה",
      "aboutus": "אודות",
      "logout": "התנתק",
      "regulation": "תקנון",
      "delete": "מחיקה",
      "break": "הפקסה",
      "newline": "חידוש תור",
      "createline": "צור תור",
      "createlines": "צור תורים",
      "choice": "בחירה",
      "deletebreak": "מחק הפסקה",
      "deleteall": "מחק הכל",
      "yes": "כן",
      "cosmetics": "קוסמטיקה",
      "barbershop": "מספרה",
      "reviews": "ביקורות",
      "extra": "אקסטרה",
      "dayswork": "ימי עבודה",
      'hairDonation': "תרומת שיער",
      "hairWash": "חפיפה חינם",
      "parking": "חניה",
      "followingyou": "עוקב/ת אחריך",
      "sendrequest": "נשלח בקשת חברות",
      "friendsnow": "ואת/ה חברים כעט",
      "sendrequestLine": "נשלח בקשה לתור",
      "linedelay": "עדכון תור מתעכב",
      "canceledline": "עדכון תור התבטל",
      "categories": "קטגוריות",
      "friendrequestmust": "כדי לשלוח בקשה הזן \n שם ופלאפון",
      "gowaze": "פתח את וויז",
      "gogoogle": "פתח את גוגל ",
      "call": "התקשר",
      "showprofile": "ראה פרופיל",
      "invitefriend": "הזמן חברים",
      "waiting": "ממתין",
      "friend": "חברים",
      "addreviews": "הוסף ביקורת",
      "changecard": "החלף כרטיס אשראי",
      "trial": "תקופת ניסיון ",
      "history": "היסטוריה",
      "offers": "הצעות",
      "choicekind": "בחר סוג",
      "price": "מחיר",
      "duration": "זמן מ10 דק - 120",
      "apptutorial": "הדרכה לאפליקציה ",
      "date": "תאריך",
      "time": "זמן",
      "sentrequest": "שלח בקשה",
      "invalidnumber": "מספר לא תקין",
      "invalidname": "הכנס שם",
      "typeofbusiness": "סוג העסק שלך",
      "addlocation": "הוספת מיקום",
      "searchaddress": "חיפוש כתובת",
      "onemoment": "עוד רגע מתחילים",
      "betaversion": "גרסת ניסיון",
      "noresults": "באזורך אין תוצאות",
      "deleteaccont": "מחק חשבון",
      "areusure": "האם אתה בטוח",
      "skip": "דלג",
      "businessowner": "בעל עסק",
      "client": "לקוח",
      "trialsearch":
          "חיפוש מספרות וקוסמטיקות\n תוצאות באזורך ברשימה\nמפה והמלצות ",
      "trialwatchbusines": "צפה בעסקים",
      "trialwatchbusiness":
          "צפה בימי עבודה, קטגוריות\nמחירים ותמונות\n ניתן לעקוב ולשלוח בקשת חברות",
      "trialmakeappoint": "קביעת תור",
      "trialmakeappoints":
          "אחרי שבעל העסק אישר אותך\n ניתן לבדוק תורים זמינים\n לשלוח בקשות לתורים\n ואפילו לנווט לבית העסק",
      "trialrequestline": "בקשה לתור",
      "trialrequestlines":
          "בחירת תאריך, שם עובד\n סוג עבודה \n וצפה בתורים זמינים",
      "trialaddworker": "הוספת עובדים",
      "trialaddworkers":
          "הוספת עובדים לעסק שלך\n ניתן ליצור תורים במיוחד עבורם\n ושליטה מלאה על חשבונך",
      "trialaddkind": "הוספת קטגוריית עבודה",
      "trialaddkinds":
          "בחירת סוג עבודה \n לדוגמה: תספורת גבר\n בחר זמן עבודה, מחיר\n וסוג מטבע",
      "trialaddlines":
          "לאחר הוספת עובדים \n וסוג עבודה \n ניתן להוסיף תור תוך בחירה\n בעובד רלוונטי וסוג עבודה",
      "trialallline": "כל התורים והפסקות",
      "trialalllines":
          "צפה בכל התורים שיצרת\n קבע זמן הפסקה \n ניתן לסנן לפי שם עובד",
      "trialrequests": "ניתן לצפות בבקשות \n בחירת  אישור או מחיקה",
      "trialaddlineclient":
          "ניתן להוסיף תור ללקוח\n בחר שם עובד, תור זמין\n שם לקוח וסוג עבודה",
      "trialupdatelines":
          "עדכון באותו יום\n בחר שם עובד וזמן עדכון\nובלחיצה כל הרשימה תקבל עדכון מידי",
      "offline": "אינטרנט לא זמין",
      "entercode": "הכנס קוד אימות",
      "invalidcode": " קוד לא תקין או פלאפון קיים",
      "timechoicenotcorrect": "בחירת זמן לא נכונה",
      "choicesamedate": "בחר תאריך התחלה וסיום זהה",
      "edittime": "ערוך זמן",
      "chooseworkinghours": "בחר שעות עבודה",
      "beginningtime": "שעת התחלה",
      "endtime": "שעת סיום",
      "tellus": "ספר לנו על הבעיה שנתקלת",
      "choocelineorkind": " תבחר תור או סוג אחר ",
      "newupdateavailable": "עדכון גרסה זמין",
      "thereisnewversion":
          "קיימת גרסה חדשה יותר של האפליקציה אנא עדכן אותה כעת",
      "updatenow": "עדכן כעט",
      "mystore": "החנות שלי",
      "addtostore": "הוספת מוצרים לחנות",
    },
    'fr': {
      'title': 'france',
    },
    'ru': {
      'title': 'russia',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get signin {
    return _localizedValues[locale.languageCode]['signin'];
  }

  String get signup {
    return _localizedValues[locale.languageCode]['signup'];
  }

  String get signuppp {
    return _localizedValues[locale.languageCode]['signuppp'];
  }

  String get email {
    return _localizedValues[locale.languageCode]['email'];
  }

  String get emailvalidator {
    return _localizedValues[locale.languageCode]['emailvalidator'];
  }

  String get emailverification {
    return _localizedValues[locale.languageCode]['emailverification'];
  }

  String get confirmemail {
    return _localizedValues[locale.languageCode]['confirmemail'];
  }

  String get password {
    return _localizedValues[locale.languageCode]['password'];
  }

  String get passwordvalidator {
    return _localizedValues[locale.languageCode]['passwordvalidator'];
  }

  String get confirmpassword {
    return _localizedValues[locale.languageCode]['confirmpassword'];
  }

  String get confirmpasswordvalidator {
    return _localizedValues[locale.languageCode]['confirmpasswordvalidator'];
  }

  String get forgetpassword {
    return _localizedValues[locale.languageCode]['forgetpassword'];
  }

  String get login {
    return _localizedValues[locale.languageCode]['login'];
  }

  String get or {
    return _localizedValues[locale.languageCode]['or'];
  }

  String get sendmail {
    return _localizedValues[locale.languageCode]['sendmail'];
  }

  String get sendagain {
    return _localizedValues[locale.languageCode]['sendagain'];
  }

  String get contactbymail {
    return _localizedValues[locale.languageCode]['contactbymail'];
  }

  String get regulation {
    return _localizedValues[locale.languageCode]['regulation'];
  }

  String get emailexists {
    return _localizedValues[locale.languageCode]['emailexists'];
  }

  String get emailorpass {
    return _localizedValues[locale.languageCode]['emailorpass'];
  }

  String get leftTorighit {
    return _localizedValues[locale.languageCode]['leftTorighit'];
  }

  String get rightToLeft {
    return _localizedValues[locale.languageCode]['rightToLeft'];
  }

  String get linestoday {
    return _localizedValues[locale.languageCode]['linestoday'];
  }

  String get updatelines {
    return _localizedValues[locale.languageCode]['updatelines'];
  }

  String get watchalllines {
    return _localizedValues[locale.languageCode]['watchalllines'];
  }

  String get alllines {
    return _localizedValues[locale.languageCode]['alllines'];
  }

  String get addlinesexplaine {
    return _localizedValues[locale.languageCode]['addlinesexplaine'];
  }

  String get addlines {
    return _localizedValues[locale.languageCode]['addlines'];
  }

  String get addline {
    return _localizedValues[locale.languageCode]['addline'];
  }

  String get kinds {
    return _localizedValues[locale.languageCode]['kinds'];
  }

  String get update {
    return _localizedValues[locale.languageCode]['update'];
  }

  String get minute {
    return _localizedValues[locale.languageCode]['minute'];
  }

  String get timesforline {
    return _localizedValues[locale.languageCode]['timesforline'];
  }

  String get requests {
    return _localizedValues[locale.languageCode]['requests'];
  }

  String get home {
    return _localizedValues[locale.languageCode]['home'];
  }

  String get lines {
    return _localizedValues[locale.languageCode]['lines'];
  }

  String get clients {
    return _localizedValues[locale.languageCode]['clients'];
  }

  String get business {
    return _localizedValues[locale.languageCode]['business'];
  }

  String get notifications {
    return _localizedValues[locale.languageCode]['notifications'];
  }

  String get saved {
    return _localizedValues[locale.languageCode]['saved'];
  }

  String get profile {
    return _localizedValues[locale.languageCode]['profile'];
  }

  String get search {
    return _localizedValues[locale.languageCode]['search'];
  }

  String get searchby {
    return _localizedValues[locale.languageCode]['searchby'];
  }

  String get images {
    return _localizedValues[locale.languageCode]['images'];
  }

  String get settings {
    return _localizedValues[locale.languageCode]['settings'];
  }

  String get payments {
    return _localizedValues[locale.languageCode]['payments'];
  }

  String get reviewsapp {
    return _localizedValues[locale.languageCode]['reviewsapp'];
  }

  String get followers {
    return _localizedValues[locale.languageCode]['followers'];
  }

  String get follow {
    return _localizedValues[locale.languageCode]['follow'];
  }

  String get following {
    return _localizedValues[locale.languageCode]['following'];
  }

  String get fullname {
    return _localizedValues[locale.languageCode]['fullname'];
  }

  String get businessname {
    return _localizedValues[locale.languageCode]['businessname'];
  }

  String get phone {
    return _localizedValues[locale.languageCode]['phone'];
  }

  String get bio {
    return _localizedValues[locale.languageCode]['bio'];
  }

  String get gender {
    return _localizedValues[locale.languageCode]['gender'];
  }

  String get privateinformation {
    return _localizedValues[locale.languageCode]['privateinformation'];
  }

  String get location {
    return _localizedValues[locale.languageCode]['location'];
  }

  String get man {
    return _localizedValues[locale.languageCode]['man'];
  }

  String get woman {
    return _localizedValues[locale.languageCode]['woman'];
  }

  String get prefernottosay {
    return _localizedValues[locale.languageCode]['prefernottosay'];
  }

  String get camera {
    return _localizedValues[locale.languageCode]['camera'];
  }

  String get gallery {
    return _localizedValues[locale.languageCode]['gallery'];
  }

  String get cancel {
    return _localizedValues[locale.languageCode]['cancel'];
  }

  String get sharepost {
    return _localizedValues[locale.languageCode]['sharepost'];
  }

  String get loading {
    return _localizedValues[locale.languageCode]['loading'];
  }

  String get writesometing {
    return _localizedValues[locale.languageCode]['writesometing'];
  }

  String get all {
    return _localizedValues[locale.languageCode]['all'];
  }

  String get su {
    return _localizedValues[locale.languageCode]['su'];
  }

  String get mo {
    return _localizedValues[locale.languageCode]['mo'];
  }

  String get tu {
    return _localizedValues[locale.languageCode]['tu'];
  }

  String get we {
    return _localizedValues[locale.languageCode]['we'];
  }

  String get th {
    return _localizedValues[locale.languageCode]['th'];
  }

  String get fr {
    return _localizedValues[locale.languageCode]['fr'];
  }

  String get sa {
    return _localizedValues[locale.languageCode]['sa'];
  }

  String get record {
    return _localizedValues[locale.languageCode]['record'];
  }

  String get addworker {
    return _localizedValues[locale.languageCode]['addworker'];
  }

  String get version {
    return _localizedValues[locale.languageCode]['version'];
  }

  String get aboutus {
    return _localizedValues[locale.languageCode]['aboutus'];
  }

  String get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }

  String get delete {
    return _localizedValues[locale.languageCode]['delete'];
  }

  String get breakk {
    return _localizedValues[locale.languageCode]['break'];
  }

  String get newline {
    return _localizedValues[locale.languageCode]['newline'];
  }

  String get createline {
    return _localizedValues[locale.languageCode]['createline'];
  }

  String get createlines {
    return _localizedValues[locale.languageCode]['createlines'];
  }

  String get choice {
    return _localizedValues[locale.languageCode]['choice'];
  }

  String get deletebreak {
    return _localizedValues[locale.languageCode]['deletebreak'];
  }

  String get deleteall {
    return _localizedValues[locale.languageCode]['deleteall'];
  }

  String get yes {
    return _localizedValues[locale.languageCode]['yes'];
  }

  String get linescheck {
    return _localizedValues[locale.languageCode]['linescheck'];
  }

  String get requestcheck {
    return _localizedValues[locale.languageCode]['requestcheck'];
  }

  String get requestlines {
    return _localizedValues[locale.languageCode]['requestlines'];
  }

  String get requestclients {
    return _localizedValues[locale.languageCode]['requestclients'];
  }

  String get added {
    return _localizedValues[locale.languageCode]['added'];
  }

  String get lineisset {
    return _localizedValues[locale.languageCode]['lineisset'];
  }

  String get reminder {
    return _localizedValues[locale.languageCode]['reminder'];
  }

  String get cosmetics {
    return _localizedValues[locale.languageCode]['cosmetics'];
  }

  String get barbershop {
    return _localizedValues[locale.languageCode]['barbershop'];
  }

  String get reviews {
    return _localizedValues[locale.languageCode]['reviews'];
  }

  String get extra {
    return _localizedValues[locale.languageCode]['extra'];
  }

  String get dayswork {
    return _localizedValues[locale.languageCode]['dayswork'];
  }

  String get hairDonation {
    return _localizedValues[locale.languageCode]['hairDonation'];
  }

  String get hairWash {
    return _localizedValues[locale.languageCode]['hairWash'];
  }

  String get parking {
    return _localizedValues[locale.languageCode]['parking'];
  }

  String get followingyou {
    return _localizedValues[locale.languageCode]['followingyou'];
  }

  String get sendrequest {
    return _localizedValues[locale.languageCode]['sendrequest'];
  }

  String get friendsnow {
    return _localizedValues[locale.languageCode]['friendsnow'];
  }

  String get sendrequestLine {
    return _localizedValues[locale.languageCode]['sendrequestLine'];
  }

  String get linedelay {
    return _localizedValues[locale.languageCode]['linedelay'];
  }

  String get canceledline {
    return _localizedValues[locale.languageCode]['canceledline'];
  }

  String get accept {
    return _localizedValues[locale.languageCode]['accept'];
  }

  String get requestclientsrelly {
    return _localizedValues[locale.languageCode]['requestclientsrelly'];
  }

  String get categories {
    return _localizedValues[locale.languageCode]['categories'];
  }

  String get friendrequestmust {
    return _localizedValues[locale.languageCode]['friendrequestmust'];
  }

  String get gogoogle {
    return _localizedValues[locale.languageCode]['gogoogle'];
  }

  String get gowaze {
    return _localizedValues[locale.languageCode]['gowaze'];
  }

  String get call {
    return _localizedValues[locale.languageCode]['call'];
  }

  String get showprofile {
    return _localizedValues[locale.languageCode]['showprofile'];
  }

  String get invitefriend {
    return _localizedValues[locale.languageCode]['invitefriend'];
  }

  String get request {
    return _localizedValues[locale.languageCode]['request'];
  }

  String get waiting {
    return _localizedValues[locale.languageCode]['waiting'];
  }

  String get friend {
    return _localizedValues[locale.languageCode]['friend'];
  }

  String get addreviews {
    return _localizedValues[locale.languageCode]['addreviews'];
  }

  String get language {
    return _localizedValues[locale.languageCode]['language'];
  }

  String get changecard {
    return _localizedValues[locale.languageCode]['changecard'];
  }

  String get trial {
    return _localizedValues[locale.languageCode]['trial'];
  }

  String get history {
    return _localizedValues[locale.languageCode]['history'];
  }

  String get offers {
    return _localizedValues[locale.languageCode]['offers'];
  }

  String get choicekind {
    return _localizedValues[locale.languageCode]['choicekind'];
  }

  String get price {
    return _localizedValues[locale.languageCode]['price'];
  }

  String get duration {
    return _localizedValues[locale.languageCode]['duration'];
  }

  String get apptutorial {
    return _localizedValues[locale.languageCode]['apptutorial'];
  }

  String get date {
    return _localizedValues[locale.languageCode]['date'];
  }

  String get time {
    return _localizedValues[locale.languageCode]['time'];
  }

  String get sentrequest {
    return _localizedValues[locale.languageCode]['sentrequest'];
  }

  String get invalidnumber {
    return _localizedValues[locale.languageCode]['invalidnumber'];
  }

  String get invalidname {
    return _localizedValues[locale.languageCode]['invalidname'];
  }

  String get typeofbusiness {
    return _localizedValues[locale.languageCode]['typeofbusiness'];
  }

  String get addlocation {
    return _localizedValues[locale.languageCode]['addlocation'];
  }

  String get searchaddress {
    return _localizedValues[locale.languageCode]['searchaddress'];
  }

  String get onemoment {
    return _localizedValues[locale.languageCode]['onemoment'];
  }

  String get betaversion {
    return _localizedValues[locale.languageCode]['betaversion'];
  }

  String get noresults {
    return _localizedValues[locale.languageCode]['noresults'];
  }

  String get deleteaccont {
    return _localizedValues[locale.languageCode]['deleteaccont'];
  }

  String get areusure {
    return _localizedValues[locale.languageCode]['areusure'];
  }

  String get skip {
    return _localizedValues[locale.languageCode]['skip'];
  }

  String get businessowner {
    return _localizedValues[locale.languageCode]['businessowner'];
  }

  String get client {
    return _localizedValues[locale.languageCode]['client'];
  }

  String get trialsearch {
    return _localizedValues[locale.languageCode]['trialsearch'];
  }

  String get trialwatchbusines {
    return _localizedValues[locale.languageCode]['trialwatchbusines'];
  }

  String get trialwatchbusiness {
    return _localizedValues[locale.languageCode]['trialwatchbusiness'];
  }

  String get trialmakeappoint {
    return _localizedValues[locale.languageCode]['trialmakeappoint'];
  }

  String get trialmakeappoints {
    return _localizedValues[locale.languageCode]['trialmakeappoints'];
  }

  String get trialrequestline {
    return _localizedValues[locale.languageCode]['trialrequestline'];
  }

  String get trialrequestlines {
    return _localizedValues[locale.languageCode]['trialrequestlines'];
  }

  String get trialaddworker {
    return _localizedValues[locale.languageCode]['trialaddworker'];
  }

  String get trialaddworkers {
    return _localizedValues[locale.languageCode]['trialaddworkers'];
  }

  String get trialaddkind {
    return _localizedValues[locale.languageCode]['trialaddkind'];
  }

  String get trialaddkinds {
    return _localizedValues[locale.languageCode]['trialaddkinds'];
  }

  String get trialaddlines {
    return _localizedValues[locale.languageCode]['trialaddlines'];
  }

  String get trialallline {
    return _localizedValues[locale.languageCode]['trialallline'];
  }

  String get trialalllines {
    return _localizedValues[locale.languageCode]['trialalllines'];
  }

  String get trialrequests {
    return _localizedValues[locale.languageCode]['trialrequests'];
  }

  String get trialaddlineclient {
    return _localizedValues[locale.languageCode]['trialaddlineclient'];
  }

  String get trialupdatelines {
    return _localizedValues[locale.languageCode]['trialupdatelines'];
  }

  String get offline {
    return _localizedValues[locale.languageCode]['offline'];
  }

  String get entercode {
    return _localizedValues[locale.languageCode]['entercode'];
  }

  String get invalidcode {
    return _localizedValues[locale.languageCode]['invalidcode'];
  }

  String get timechoicenotcorrect {
    return _localizedValues[locale.languageCode]['timechoicenotcorrect'];
  }

  String get choicesamedate {
    return _localizedValues[locale.languageCode]['choicesamedate'];
  }

  String get edittime {
    return _localizedValues[locale.languageCode]['edittime'];
  }

  String get beginningtime {
    return _localizedValues[locale.languageCode]['beginningtime'];
  }

  String get endtime {
    return _localizedValues[locale.languageCode]['endtime'];
  }

  String get chooseworkinghours {
    return _localizedValues[locale.languageCode]['chooseworkinghours'];
  }

  String get tellus {
    return _localizedValues[locale.languageCode]['tellus'];
  }

  String get choocelineorkind {
    return _localizedValues[locale.languageCode]['choocelineorkind'];
  }

  String get newupdateavailable {
    return _localizedValues[locale.languageCode]['newupdateavailable'];
  }

  String get thereisnewversion {
    return _localizedValues[locale.languageCode]['thereisnewversion'];
  }

  String get updatenow {
    return _localizedValues[locale.languageCode]['updatenow'];
  }

  String get mystore {
    return _localizedValues[locale.languageCode]['mystore'];
  }

  String get description {
    return _localizedValues[locale.languageCode]['description'];
  }

  String get available {
    return _localizedValues[locale.languageCode]['available'];
  }

  String get addtostore {
    return _localizedValues[locale.languageCode]['addtostore'];
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      // ['en', 'he', 'fr', 'ru'].contains(locale.languageCode);
      ['en', 'he'].contains(locale.languageCode);
  @override
  Future<DemoLocalizations> load(Locale locale) {
    return new SynchronousFuture<DemoLocalizations>(
        new DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
