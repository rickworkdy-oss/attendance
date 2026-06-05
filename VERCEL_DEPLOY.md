# 🚀 Deploying to Vercel - Step by Step Guide

This guide will help you deploy your Digiledger Attendance web app to Vercel in under 10 minutes.

## Prerequisites

- A Vercel account (free) - sign up at [vercel.com](https://vercel.com)
- Your Supabase credentials ready (URL and anon key)
- Git installed on your computer

---

## Option 1: Deploy via Vercel CLI (Fastest)

### Step 1: Install Vercel CLI

```bash
npm install -g vercel
```

### Step 2: Login to Vercel

```bash
vercel login
```

Follow the prompts to authenticate.

### Step 3: Deploy

From your `attendance-web` folder:

```bash
cd attendance-web
vercel
```

You'll be asked:
1. **Set up and deploy?** → Yes
2. **Which scope?** → Select your account
3. **Link to existing project?** → No
4. **Project name?** → `attendance-web` (or your preferred name)
5. **Which directory?** → `.` (current directory)
6. **Override settings?** → No

### Step 4: Add Environment Variables

After deployment, go to your Vercel dashboard:

1. Go to [vercel.com/dashboard](https://vercel.com/dashboard)
2. Click on your project
3. Go to **Settings** → **Environment Variables**
4. Add two variables:

   ```
   Name: NEXT_PUBLIC_SUPABASE_URL
   Value: https://your-project.supabase.co
   
   Name: NEXT_PUBLIC_SUPABASE_ANON_KEY
   Value: your-anon-key-here
   ```

5. Click **Save**

### Step 5: Redeploy

To apply the environment variables:

```bash
vercel --prod
```

**Done!** Your app is live at the URL shown in the terminal.

---

## Option 2: Deploy via GitHub (Recommended for Teams)

### Step 1: Initialize Git Repository

If you haven't already:

```bash
cd attendance-web
git init
```

### Step 2: Create .gitignore

Ensure your `.gitignore` includes:

```
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.js

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# local env files
.env*.local
.env

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts
```

### Step 3: Commit Your Code

```bash
git add .
git commit -m "Initial commit - Digiledger Attendance Web App"
```

### Step 4: Push to GitHub

1. **Create a new repository on GitHub:**
   - Go to [github.com/new](https://github.com/new)
   - Name it `attendance-web` (or your preferred name)
   - Don't initialize with README (you already have one)
   - Click "Create repository"

2. **Push your code:**

   ```bash
   git remote add origin https://github.com/YOUR-USERNAME/attendance-web.git
   git branch -M main
   git push -u origin main
   ```

### Step 5: Connect to Vercel

1. Go to [vercel.com/new](https://vercel.com/new)
2. Click **"Import Git Repository"**
3. Select your GitHub account and the `attendance-web` repository
4. Click **"Import"**

### Step 6: Configure Project

Vercel will auto-detect it's a Next.js project. You just need to add environment variables:

1. In the **"Configure Project"** section, expand **"Environment Variables"**

2. Add your Supabase credentials:

   ```
   Name: NEXT_PUBLIC_SUPABASE_URL
   Value: https://your-project.supabase.co
   
   Name: NEXT_PUBLIC_SUPABASE_ANON_KEY
   Value: your-anon-key-here
   ```

3. Click **"Deploy"**

### Step 7: Wait for Deployment

Vercel will:
- Install dependencies
- Build your project
- Deploy to production

This takes 2-3 minutes.

### Step 8: View Your Live Site

Once done, you'll see:
- ✅ Deployment successful
- Your live URL: `https://attendance-web-xxxxx.vercel.app`

Click the URL to visit your live site!

---

## Post-Deployment Steps

### 1. Test Your App

Visit your live URL and test:
- ✅ Attendance page loads
- ✅ Can mark attendance
- ✅ Employees page loads
- ✅ Can add employee
- ✅ Payroll page loads

### 2. Custom Domain (Optional)

To add your own domain (e.g., `attendance.yourcompany.com`):

1. Go to Vercel Dashboard → Your Project
2. Click **"Settings"** → **"Domains"**
3. Add your domain
4. Update your DNS records as instructed by Vercel

### 3. Enable Analytics (Optional)

Vercel provides free analytics:

1. Go to your project settings
2. Click **"Analytics"**
3. Enable Web Analytics

---

## Updating Your Deployed App

### If using GitHub:

1. Make changes locally
2. Commit and push:
   ```bash
   git add .
   git commit -m "Update feature X"
   git push
   ```
3. Vercel automatically redeploys!

### If using Vercel CLI:

```bash
vercel --prod
```

---

## Environment Variables Reference

| Variable | Where to Find | Example |
|----------|---------------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase Dashboard → Settings → API → Project URL | `https://abc123.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase Dashboard → Settings → API → Project API keys → anon public | `eyJhbGc...` (long string) |

---

## Troubleshooting

### Build Failed

**Error:** "Module not found"
- **Fix:** Run `npm install` locally first to ensure all dependencies are correct

**Error:** "Environment variable not found"
- **Fix:** Double-check you added both environment variables in Vercel settings

### App Loads but Shows Errors

**Error:** "Failed to load employees"
- **Fix:** Verify your Supabase credentials in Vercel environment variables
- **Fix:** Ensure `supabase.sql` was run in your Supabase project

**Error:** "CORS error" in console
- **Fix:** Supabase allows all origins by default, but check your Supabase project settings

### Can't Mark Attendance

- Check browser console for errors
- Verify Supabase RLS policies are configured correctly
- Ensure sample employees exist in database

---

## Quick Checklist

Before deploying, ensure:

- ✅ `supabase.sql` has been executed in Supabase
- ✅ You have your Supabase URL
- ✅ You have your Supabase anon key
- ✅ `.env.local.example` exists (don't commit `.env.local`!)
- ✅ All dependencies installed (`npm install`)
- ✅ App runs locally (`npm run dev`)

---

## Production URLs

After deployment, your app will be accessible at:

**Main URL:** `https://your-project-name.vercel.app`

**Alternative URLs:**
- `https://your-project-name-git-main-username.vercel.app` (Git branch)
- Your custom domain (if configured)

---

## Support

If you encounter issues:

1. Check Vercel deployment logs in your dashboard
2. Check browser console for frontend errors
3. Check Supabase logs for database errors
4. Review this guide again

---

## Next Steps

After successful deployment:

1. ✅ Share the URL with your team
2. ✅ Add custom domain (if needed)
3. ✅ Set up user authentication (future enhancement)
4. ✅ Enable Vercel Analytics
5. ✅ Configure automatic backups in Supabase

---

**Congratulations!** 🎉 Your attendance system is now live on the internet!
