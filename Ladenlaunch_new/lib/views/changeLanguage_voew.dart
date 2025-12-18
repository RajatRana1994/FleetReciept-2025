import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ladenlaunch/helpler_classes/appBar.dart';
import 'package:ladenlaunch/helpler_classes/app_colors.dart';
import 'package:ladenlaunch/helpler_classes/custom_button.dart';
import 'package:ladenlaunch/network/user_preference.dart';

class ChangeLanguageView extends StatefulWidget {
  const ChangeLanguageView({super.key});

  @override
  State<ChangeLanguageView> createState() => _ChangeLanguageViewState();
}

class _ChangeLanguageViewState extends State<ChangeLanguageView> {
  Locale currentLocale = Get.locale ?? const Locale('en', 'US');

  Widget languageTile({required String title, required Locale locale}) {
    final bool isSelected = currentLocale == locale;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentLocale = locale;
        });
      //  Get.updateLocale(locale);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? AppColors.appColor : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.appColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEBEBEB),
      appBar:  CustomAppBar(
        title: 'change_language'.tr,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          bottom: 40,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            languageTile(title: 'English', locale: const Locale('en', 'US')),
            languageTile(title: 'Spanish', locale: const Locale('es', 'ES')),

            const SizedBox(height: 50),
            CustomButton(
              title: 'submit'.tr,
              onTap: () async {
                Get.updateLocale(currentLocale);
                await DbHelper.saveAppLanguage(currentLocale);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': <String, String>{
      'change_language': 'Change Language',
      'english': 'English',
      'spanish': 'Spanish',
      'submit': 'Submit',
      'error_enter_email': 'Please enter email',
      'error_valid_email': 'Please enter a valid email',
      'error_enter_password': 'Please enter password',
      'error_enter_old_password': 'Please enter old password',
      'error_enter_new_password': 'Please enter new password',
      'error_enter_confirm_password': 'Please enter confirm password',
      'error_password_mismatch': 'New and confirm password not matched',
      'error_enter_name': 'Please enter name',
      'error_enter_phone_number': 'Please enter phone number',
      'error_enter_email_address': 'Please enter email address',

      'business_deleted_success': 'Business deleted successfully',
      'error_max_images_allowed': 'Maximum 5 images are allowed',
      'error_upload_image': 'Please upload image',
      'error_select_business': 'Please select business',
      'error_enter_description': 'Please enter description',
      'subscription_required': 'Subscription Required',
      'subscription_required_message': 'Please buy a subscription or start your 2 week free trial to continue.',
      'buy_now': 'Buy Now',
      'cancel': 'Cancel',

      'add_business': 'Add Business',
      'label_name': 'Name',
      'label_email': 'Email',
      'label_phone': 'Phone',
      'add': 'Add',

      'delete_business': 'Delete Business',
      'confirm_delete_business': 'Are you sure you want to delete this business?',
      'delete': 'Delete',
      'business_list': 'Business List',
      'no_businesses_found': 'No businesses found',
      'add_new_business': 'Add New Business',

      'change_password': 'Change Password',
      'old_password': 'Old Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm Password',
      'forgot_password': 'Forgot Password',
      'enter_email': 'Enter Email',
      'no_business_found': 'No Business Found',
      'ok': 'OK',

      'select_business': 'Select Business',
      'home': 'Home',
      'camera_max_photos': 'You can capture maximum of 5 photos',
      'camera_tap_to_capture': 'Tap to capture an image',

      'business': 'Business',
      'description': 'Description',
      'enter_description_hint': 'Enter Description',
      'send': 'Send',

      'login': 'Login',
      'password': 'Password',
      'enter_password': 'Enter Password',
      'forgot_password_question': 'Forgot Password?',
      'or_continue_with': 'Or continue with',
      'dont_have_account': "Don't have an account?",
      'sign_up': 'Sign Up',

      'privacy_policy': 'Privacy Policy',
      'logout': 'Logout',
      'confirm_logout': 'Are you sure you want to logout?',

      'delete_account': 'Delete Account',
      'confirm_delete_account': 'Are you sure you want to delete account?',

      'profile': 'Profile',
      'update_profile': 'Update Profile',
      'view_subscription': 'View Subscription',
      'support': 'Support',
      'signup': 'Signup',
      'enter_name': 'Enter Name',
      'phone_number': 'Phone Number',
      'enter_phone_number': 'Enter Phone Number',
      'already_have_account': 'Already have an account?',

      'store_not_available': 'Store not available',
      'no_products_found': 'No products found',
      'purchase_stream_error': 'Purchase stream error',
      'purchase_cancelled': 'Purchase cancelled',

      'subscription_activated_success': 'Subscription activated successfully!',
      'no_subscription_product_found': 'No subscription product found',
      'subscription_already_active': 'You already have an active subscription. You can manage or cancel it in your App Store settings.',
      'already_subscribed': 'Already Subscribed',
      'ok_button': 'Ok',
      'purchase_is_cancelled': 'Purchase is cancelled',

      'subscription': 'Subscription',
      'choose_subscription_plan': 'Choose a subscription plan',
      'monthly_subscription': 'Monthly Subscription',
      'subscription_unlimited_emails': 'Send unlimited emails every month',
      'month': 'month',

      'subscription_free_trial_info': 'Free Trial: 30 days. After the free trial ends, your subscription will automatically renew unless canceled at least 24 hours before renewal.',
      'subscription_terms_prefix': 'By subscribing, you agree to our',
      'terms_of_use': 'Terms of Use',
      'and': 'and',
      'start_free_trial': 'Start your 2-week free trial',

      'active': 'ACTIVE',
      'best_for': 'Best for:',
      'avg_response': 'Avg Response:',

      'contact_support': 'Contact & Support',
      'support_24_7': 'We''re here to help you 24/7',
      'support_description': 'Need help with scanning receipts, expense reports, approvals, or anything else?',
      'support_detailed_questions': 'Detailed questions, attachments, account issues',
      'support_email_response': '< 4 hours (often < 1 hour)',

      'support_phone_text': 'Phone / Text',
      'support_urgent_issues': 'Urgent issues, quick questions',
      'support_phone_response': '< 10 minutes (7am–10pm EST)',

      'support_in_app_chat': 'In-App Chat',
      'support_chat_hint': 'Tap the ? icon → Message Us',
      'support_while_using_app': 'While using the app',
      'support_chat_response': '< 5 minutes',

      'support_hours' :'Support Hours',
      'support_hours_phone': 'Phone & Text: 7 days a week, 7 AM – 10 PM Eastern Time',
      'support_hours_email': 'Email & In-App Chat: 24/7 (usually within minutes)',

      'download_update_app': 'Download or Update the App',
      'app_store_ios': 'App Store (iOS)',
      'google_play_android': 'Google Play (Android)',

      'businesses': 'Businesses',
      'my_profile': 'My Profile',
      'edit_profile': 'Edit Profile',

    },
    'es_ES': {
      'change_language': 'Cambiar idioma',
      'english': 'Inglés',
      'spanish': 'Español',
      'submit': 'Enviar',

      'error_enter_email': 'Por favor introduce el correo electrónico',
      'error_valid_email': 'Por favor introduce un correo electrónico válido',
      'error_enter_password': 'Por favor introduce la contraseña',
      'error_enter_old_password': 'Por favor introduce la contraseña anterior',
      'error_enter_new_password': 'Por favor introduce la nueva contraseña',
      'error_enter_confirm_password': 'Por favor confirma la nueva contraseña',
      'error_password_mismatch': 'La nueva contraseña y la confirmación no coinciden',
      'error_enter_name': 'Por favor introduce el nombre',
      'error_enter_phone_number': 'Por favor introduce el número de teléfono',
      'error_enter_email_address': 'Por favor introduce la dirección de correo electrónico',

      'business_deleted_success': 'Negocio eliminado correctamente',
      'error_max_images_allowed': 'Se permiten máximo 5 imágenes',
      'error_upload_image': 'Por favor sube una imagen',
      'error_select_business': 'Por favor selecciona un negocio',
      'error_enter_description': 'Por favor introduce la descripción',
      'subscription_required': 'Suscripción requerida',
      'subscription_required_message': 'Por favor compra una suscripción o inicia tu prueba gratuita de 2 semanas para continuar.',
      'buy_now': 'Comprar ahora',
      'cancel': 'Cancelar',

      'add_business': 'Agregar negocio',
      'label_name': 'Nombre',
      'label_email': 'Correo electrónico',
      'label_phone': 'Teléfono',
      'add': 'Agregar',

      'delete_business': 'Eliminar negocio',
      'confirm_delete_business': '¿Estás seguro de que deseas eliminar este negocio?',
      'delete': 'Eliminar',
      'business_list': 'Lista de negocios',
      'no_businesses_found': 'No se encontraron negocios',
      'add_new_business': 'Agregar nuevo negocio',

      'change_password': 'Cambiar contraseña',
      'old_password': 'Contraseña anterior',
      'new_password': 'Nueva contraseña',
      'confirm_password': 'Confirmar contraseña',
      'forgot_password': 'Olvidé mi contraseña',
      'enter_email': 'Introduce el correo electrónico',
      'no_business_found': 'No se encontró ningún negocio',
      'ok': 'OK',

      'select_business': 'Seleccionar negocio',
      'home': 'Inicio',
      'camera_max_photos': 'Puedes capturar un máximo de 5 fotos',
      'camera_tap_to_capture': 'Toca para capturar una imagen',

      'business': 'Negocio',
      'description': 'Descripción',
      'enter_description_hint': 'Introduce la descripción',
      'send': 'Enviar',

      'login': 'Iniciar sesión',
      'password': 'Contraseña',
      'enter_password': 'Introduce la contraseña',
      'forgot_password_question': '¿Olvidaste tu contraseña?',
      'or_continue_with': 'O continúa con',
      'dont_have_account': "¿No tienes una cuenta?",
      'sign_up': 'Regístrate',

      'privacy_policy': 'Política de privacidad',
      'logout': 'Cerrar sesión',
      'confirm_logout': '¿Estás seguro de que deseas cerrar sesión?',

      'delete_account': 'Eliminar cuenta',
      'confirm_delete_account': '¿Estás seguro de que deseas eliminar la cuenta?',

      'profile': 'Perfil',
      'update_profile': 'Actualizar perfil',
      'view_subscription': 'Ver suscripción',
      'support': 'Soporte',
      'signup': 'Registrarse',
      'enter_name': 'Introduce el nombre',
      'phone_number': 'Número de teléfono',
      'enter_phone_number': 'Introduce el número de teléfono',
      'already_have_account': '¿Ya tienes una cuenta?',

      'store_not_available': 'Tienda no disponible',
      'no_products_found': 'No se encontraron productos',
      'purchase_stream_error': 'Error en la compra de la suscripción',
      'purchase_cancelled': 'Compra cancelada',

      'subscription_activated_success': '¡Suscripción activada correctamente!',
      'no_subscription_product_found': 'No se encontró ningún producto de suscripción',
      'subscription_already_active': 'Ya tienes una suscripción activa. Puedes gestionarla o cancelarla en la configuración de tu App Store.',
      'already_subscribed': 'Ya estás suscrito',
      'ok_button': 'Ok',
      'purchase_is_cancelled': 'La compra ha sido cancelada',

      'subscription': 'Suscripción',
      'choose_subscription_plan': 'Elige un plan de suscripción',
      'monthly_subscription': 'Suscripción mensual',
      'subscription_unlimited_emails': 'Envía correos electrónicos ilimitados cada mes',
      'month': 'mes',

      'subscription_free_trial_info': 'Prueba gratuita: 30 días. Después de que termine la prueba gratuita, tu suscripción se renovará automáticamente a menos que la canceles al menos 24 horas antes de la renovación.',
      'subscription_terms_prefix': 'Al suscribirte, aceptas nuestros',
      'terms_of_use': 'Términos de uso',
      'and': 'y',
      'start_free_trial': 'Inicia tu prueba gratuita de 2 semanas',

      'active': 'ACTIVA',
      'best_for': 'Ideal para:',
      'avg_response': 'Tiempo de respuesta promedio:',

      'contact_support': 'Contacto y soporte',
      'support_24_7': 'Estamos aquí para ayudarte 24/7',
      'support_description': '¿Necesitas ayuda con el escaneo de recibos, reportes de gastos, aprobaciones o cualquier otra cosa?',
      'support_detailed_questions': 'Preguntas detalladas, archivos adjuntos, problemas de cuenta',
      'support_email_response': '< 4 horas (a menudo < 1 hora)',

      'support_phone_text': 'Teléfono / Mensajes de texto',
      'support_urgent_issues': 'Problemas urgentes, preguntas rápidas',
      'support_phone_response': '< 10 minutos (7 am–10 pm hora del este de EE. UU.)',

      'support_in_app_chat': 'Chat dentro de la app',
      'support_chat_hint': 'Toca el ícono de ? → Envíanos un mensaje',
      'support_while_using_app': 'Mientras usas la app',
      'support_chat_response': '< 5 minutos',

      'support_hours' :'Horario de soporte',
      'support_hours_phone': 'Teléfono y mensajes de texto: 7 días a la semana, 7 am – 10 pm hora del este de EE. UU.',
      'support_hours_email': 'Correo electrónico y chat en la app: 24/7 (normalmente en pocos minutos)',

      'download_update_app': 'Descarga o actualiza la app',
      'app_store_ios': 'App Store (iOS)',
      'google_play_android': 'Google Play (Android)',

      'businesses': 'Negocios',
      'my_profile': 'Mi perfil',
      'edit_profile': 'Editar perfil',
    },
  };
}

