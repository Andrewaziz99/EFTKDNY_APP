import 'package:eftkdny/shared/network/local/cache_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../modules/Auth/login_screen.dart';
import 'components.dart';

void signOut(context) {
  CacheHelper.removeData(key: 'uId').then((value) {
    if (value) {
      navigateAndFinish(context, LoginScreen());
    }
  });

  CacheHelper.removeAllData();
}

void printFullText(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String defaultChildImage = 'https://cdn-icons-png.flaticon.com/128/945/945265.png';

String uId = '';

String userYear = '';

final List<String> classItems = [
  'اسرة ملائكة',
  'اسرة1',
  'اسرة القديس مارجرجس وابونا فلتاؤس',
  'اسرة2',
  'اسرة القديس ابانوب',
  'اسرة الانبا انطونيوس',
  'اسرة الانبا بولا',
];

const String appVersion = '1.0.0';

const String appName = 'إفتقدني';

//Buttons
const String register = 'سجل';
const String login = 'تسجيل الدخول';
const String logout = 'تسجيل الخروج';
const String reset = 'إعادة تعيين كلمة المرور';
const String dontHaveAccount = 'ليس لديك حساب؟';
const String send = 'إرسال';
const String submit = 'تسجيل';
const String update = 'تحديث';
const String delete = 'حذف';
const String add = 'إضافة';
const String edit = 'تعديل';
const String home = 'الرئيسية';
const String attendance = 'الحضور';
const String friday_attendance = ' حضور مدارس الأحد';
const String hymns_attendance =  'حضور الاحان';
const String settings = 'الاعدادات';
const String profile = 'الملف الشخصي';
const String about = 'حول';
const String contactUs = 'تواصل معنا';
const String exit = 'خروج';
const String cancel = 'إلغاء';
const String yes = 'نعم';
const String no = 'لا';
const String ok = 'حسنا';
const String done = 'تم';
const String attendanceDone = 'تم تسجيل الحضور';
const String next = 'التالي';
const String finish = 'إنهاء';

// Messages
const String error = 'خطأ';
const String success = 'نجاح';
const String warning = 'تحذير';
const String info = 'معلومات';
const String loading = 'جاري التحميل...';
const String noData = 'لا توجد بيانات';
const String noInternet = 'لا يوجد اتصال بالإنترنت';
const String imageSelected = 'تم اختيار الصورة';
const String imageNotSelected = 'لم يتم اختيار الصورة';
const String confirmLogout = 'هل انت متأكد من تسجيل الخروج؟';

const String email = 'البريد الإلكتروني';
const String password = 'كلمة المرور';
const String confirmemail = 'تأكيد البريد الإلكتروني';
const String confirmPassword = 'تأكيد كلمة المرور';
const String name = 'الاسم';
const String phone = 'رقم الهاتف';
const String address = 'العنوان';
const String birthdate = 'تاريخ الميلاد';
const String selectClass = 'اختر الأسرة';
const String selectYear = 'اختر السنة';
const String selectImage = 'اختر صورة';

const String emptyName = 'الاسم مطلوب';
const String emptyPhone = 'رقم الهاتف مطلوب';
const String emptyAddress = 'العنوان مطلوب';
const String emptyClass = 'الأسرة مطلوبة';
const String emptyBirthdate = 'تاريخ الميلاد مطلوب';
const String emptyPassword = 'كلمة المرور مطلوبة';
const String emptyConfirmPassword = 'تأكيد كلمة المرور مطلوب';
const String emptyEmail = 'البريد الإلكتروني مطلوب';
const String emailValidation = 'البريد الإلكتروني غير صالح';
const String passwordValidation = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
const String confirmPasswordValidation = 'تأكيد كلمة المرور غير متطابق';
const String nameValidation = 'الاسم مطلوب';
const String phoneValidation = 'رقم الهاتف غير صالح';
const String addressValidation = 'العنوان مطلوب';
const String birthdateValidation = 'تاريخ الميلاد مطلوب';
const String selectClassValidation = 'الرجاء اختيار الأسرة';
const String selectYearValidation = 'الرجاء اختيار السنة';
const String selectImageValidation = 'الرجاء اختيار صورة';

const String childData = 'بيانات الطفل';

const String emailVerification = 'التحقق من البريد الإلكتروني';

const String loginSuccess = 'تم تسجيل الدخول بنجاح';
const String loginError = 'خطأ في تسجيل الدخول';
const String registerSuccess = 'تم التسجيل بنجاح';
const String registerError = 'خطأ في التسجيل';
const String updateSuccess = 'تم التحديث بنجاح';
const String updateError = 'خطأ في التحديث';
const String deleteSuccess = 'تم الحذف بنجاح';
const String deleteError = 'خطأ في الحذف';
const String addSuccess = 'تمت الإضافة بنجاح';
const String addError = 'خطأ في الإضافة';

const String forgotPassword = 'نسيت كلمة المرور؟';

const String welcome = 'مرحبا بك في إفتقدني';

const String developer = 'تطوير: اندرو عزيز';
const String aboutApp = 'إفتقدني هو تطبيق يهدف إلى تسهيل ومتابعة الإفتقاد والطفل';

const String myEmail = 'andrewmichel2002@gmail.com';
const String myPhone = '01285928101';

const String emailCopied = 'تم نسخ البريد';

const String contactUsMessage = 'تواصل معنا عبر البريد الالكتروني';
const String contactUsEmail = 'تواصل معنا عبر البريد الالكتروني';
const String contactUsPhone = 'تواصل معنا عبر الهاتف';


const String noChildrenLeft = 'لم يتبق أطفال لتسجيل حضورهم';


const String startVisit = 'بدء الزيارة';
const String headLine1 = 'بيانات الإفتقاد:';


const String date = 'التاريخ';

const String q1 = 'اخر مرة اتناولت فيها ؟';
const String q2 = 'اخر مرة صليت؟';
const String q3 = 'اخر مرة قرأت فيها الانجيل؟';
const String q4 = 'اخر مرة اعترفت؟';


List<String> questions = [
  q3,
  q2,
  q1,
  q4,
];

Future<void> call(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch phone call';
  }
}