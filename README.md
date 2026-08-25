# SudaCards POS — Deployment Configuration (Dokploy)

مستودع إعدادات وتشغيل نظام **SudaCards POS** باستخدام **Docker Compose** على خوادم VPS التي تعمل بنظام **Dokploy**.

---

## 📦 محتويات المستودع:
* `docker-compose.yml`: ملف التكوين الرئيسي لتشغيل الحاويات (تطبيق الويب + قاعدة بيانات PostgreSQL).
* `.env.example`: نموذج متغيرات البيئة وكلمات المرور.

---

## 🚀 طريقة النشر والتشغيل على Dokploy (Hostinger VPS):

### 1. في لوحة تحكم Dokploy:
1. اذهب إلى **Projects** ثم أنشئ مشروعاً جديداً (مثال: `sudacardspos`).
2. اضغط **Create Service** واختر نوع **Compose**.
3. في تبويب **Source**:
   * اختر **Git**.
   * اختر هذا المستودع `sudacards-pos-deployment`.
   * اختر الفرع `main`.
4. في تبويب **Environment**:
   * انسخ المتغيرات من `.env.example` وعدل كلمات المرور والدومين.
5. في تبويب **Domains**:
   * أضف الدومين الخاص بك وحدد المنفذ `8080`.
   * فعّل شهادة الحماية المجانية **HTTPS (Let's Encrypt)**.
6. اضغط على زر **Deploy** في الأعلى.

---

## 🛠️ التشغيل المحلي عبر Docker:
```bash
docker compose up -d
```
