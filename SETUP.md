# 🚀 Complete Setup Guide

Get your Digiledger Attendance Web App running in 5 minutes!

## 📋 What You Need

1. **Supabase Account** (free) - [Sign up here](https://supabase.com)
2. **Vercel Account** (free) - [Sign up here](https://vercel.com) *(for deployment)*
3. **Node.js 18+** - Check with `node --version`

---

## Step 1: Database Setup (3 minutes)

### 1.1 Create Supabase Project

1. Go to [supabase.com](https://supabase.com) and sign in
2. Click **"New Project"**
3. Fill in:
   - Name: `digiledger-attendance`
   - Database Password: (choose a strong password)
   - Region: (choose closest to you)
4. Click **"Create new project"**
5. Wait 2-3 minutes for setup to complete

### 1.2 Run Database Schema

1. In Supabase dashboard, click **SQL Editor** in the left sidebar
2. Click **"New Query"**
3. Open the `supabase.sql` file in this folder
4. Copy **ALL** contents (Ctrl+A, Ctrl+C)
5. Paste into SQL Editor (Ctrl+V)
6. Click **"Run"** (or press Ctrl+Enter)
7. You should see: ✅ **"Success. No rows returned"**

### 1.3 Get Your Credentials

1. Click the **Settings** icon (⚙️) in the left sidebar
2. Click **API**
3. Copy these two values:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public key** (long string starting with `eyJ...`)

---

## Step 2: Local Development (2 minutes)

### 2.1 Install Dependencies

```bash
cd attendance-web
npm install
```

### 2.2 Configure Environment

1. Copy the environment template:
   ```bash
   cp .env.local.example .env.local
   ```

2. Edit `.env.local` with your text editor:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

3. Paste your actual Supabase credentials from Step 1.3

### 2.3 Run Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

You should see the attendance app with the navigation bar!

---

## Step 3: Test the App (2 minutes)

### 3.1 Test Attendance Page

1. You should see 3 sample employees (from the SQL script)
2. Click on employee names to toggle Present/Absent
3. Click **"Save Attendance"**
4. You should see "Attendance saved successfully!"

### 3.2 Test Employees Page

1. Click **"Employees"** in the top navigation
2. Click **"+ Add Employee"**
3. Fill in:
   - Name: `Test Employee`
   - Designation: `Developer`
   - Daily Wage: `50`
4. Click **"Add Employee"**
5. You should see the new employee in the list

### 3.3 Test Payroll Page

1. Click **"Payroll"** in the top navigation
2. You should see a summary of wages
3. Try changing the date range from Weekly to Monthly
4. Try filtering by a specific employee

If all 3 pages work, you're ready to deploy! 🎉

---

## Step 4: Deploy to Vercel (5 minutes)

See [VERCEL_DEPLOY.md](./VERCEL_DEPLOY.md) for detailed deployment instructions.

**Quick version:**

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

2. **Login:**
   ```bash
   vercel login
   ```

3. **Deploy:**
   ```bash
   vercel
   ```

4. **Add Environment Variables:**
   - Go to Vercel Dashboard → Your Project → Settings → Environment Variables
   - Add `NEXT_PUBLIC_SUPABASE_URL`
   - Add `NEXT_PUBLIC_SUPABASE_ANON_KEY`

5. **Redeploy:**
   ```bash
   vercel --prod
   ```

**Your app is now live!** 🚀

---

## 🎯 Quick Troubleshooting

### "Failed to load employees"

**Cause:** Supabase credentials are incorrect or not set

**Fix:**
1. Check `.env.local` has the correct values
2. Restart dev server: Stop (Ctrl+C) and run `npm run dev` again
3. Check browser console (F12) for specific errors

### "Cannot connect to database"

**Cause:** Supabase project not set up or SQL not run

**Fix:**
1. Go to Supabase → SQL Editor
2. Re-run the `supabase.sql` script
3. Check for any error messages

### Calendar not showing

**Cause:** CSS not loading

**Fix:**
```bash
npm install react-calendar
```

Then restart dev server.

### Build errors

**Cause:** TypeScript errors or missing dependencies

**Fix:**
```bash
# Clean install
rm -rf node_modules package-lock.json
npm install

# Try building
npm run build
```

### Port 3000 already in use

**Fix:**
```bash
# Use a different port
npm run dev -- -p 3001
```

---

## 📊 Database Schema Overview

The `supabase.sql` file creates:

### Tables
1. **employees** - Staff information
   - `employee_id`, `full_name`, `designation`, `is_active`

2. **employee_wages** - Historical wage tracking
   - `wage_id`, `employee_id`, `daily_wage`
   - `effective_from_date`, `effective_to_date`

3. **attendance** - Daily attendance records
   - `attendance_id`, `employee_id`, `date`, `status`

### Sample Data
- 3 employees (John Doe, Jane Smith, Bob Johnson)
- Initial wages of ₹40/day for each

### Functions
- `get_employee_wage_for_date()` - Get wage for specific date
- `update_employee_wage()` - Update wage with history

---

## 🔐 Security Notes

### Important Files

✅ **Safe to commit:**
- `.env.local.example` (template)
- `supabase.sql` (schema)
- All source code

❌ **NEVER commit:**
- `.env.local` (contains secrets)
- `.env` (if you create it)

### gitignore

The project includes a `.gitignore` that prevents committing secrets.

Always verify before pushing:
```bash
git status  # Check what will be committed
```

---

## 📁 Project Structure

```
attendance-web/
├── app/
│   ├── attendance/page.tsx    # Daily tracker
│   ├── employees/page.tsx     # Employee management
│   ├── payroll/page.tsx       # Payroll dashboard
│   └── layout.tsx             # Main layout with nav
├── components/
│   └── Navigation.tsx         # Top nav bar
├── lib/
│   ├── supabase.ts           # DB client
│   └── dateUtils.ts          # Date helpers
├── .env.local                # YOUR CREDENTIALS (don't commit!)
├── .env.local.example        # Template
├── supabase.sql              # Database schema
├── SETUP.md                  # This file
├── VERCEL_DEPLOY.md          # Deployment guide
└── README.md                 # Full documentation
```

---

## 🎓 Next Steps

After setup:

1. ✅ **Customize the app**
   - Change company name in Navigation
   - Adjust default wage amounts
   - Add more employee fields

2. ✅ **Add features**
   - User authentication
   - Export to PDF/Excel
   - Email reports
   - Mobile responsive improvements

3. ✅ **Deploy to production**
   - Follow VERCEL_DEPLOY.md
   - Add custom domain
   - Enable analytics

4. ✅ **Share with team**
   - Send the Vercel URL
   - Train staff on usage
   - Set up regular backups

---

## 💡 Pro Tips

1. **Use sample data** - The SQL script includes 3 test employees. Use them to learn the system before adding real data.

2. **Test wage changes** - Mark attendance, update an employee's wage, mark more attendance, then check payroll to see the wage change indicator.

3. **Weekly vs Monthly** - Weekly view is better for day-to-day management. Monthly view is better for payroll processing.

4. **Keyboard shortcuts**
   - `npm run dev` - Start dev server
   - Ctrl+C - Stop dev server
   - F5 - Refresh browser
   - F12 - Open browser console (for debugging)

---

## 🆘 Still Need Help?

1. **Check the docs:**
   - [README.md](./README.md) - Full documentation
   - [VERCEL_DEPLOY.md](./VERCEL_DEPLOY.md) - Deployment guide

2. **Common issues:**
   - Review the Troubleshooting section above
   - Check browser console (F12)
   - Check Supabase logs

3. **Database issues:**
   - View Supabase logs: Dashboard → Logs
   - Test connection: Dashboard → Table Editor

---

**Happy Tracking!** 📊✨

Need more help? Review the other documentation files in this folder.
