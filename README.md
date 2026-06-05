# Digiledger Attendance Web App

A modern web-based staff attendance and payroll tracking application built with Next.js 15, TypeScript, and Tailwind CSS.

## 🚀 Features

### 1. Daily Attendance Tracker
- Interactive calendar for date selection
- View all active employees
- Quick toggle to mark Present/Absent
- Real-time status updates
- Save attendance records

### 2. Employee Management
- Add new employees with designation and wages
- Update employee wages with historical tracking
- Wage updates automatically close previous records
- Activate/deactivate employees
- View current wage and effective dates

### 3. Payroll Dashboard
- Filter by Weekly or Monthly date ranges
- Filter by specific employee or view all
- Automatic wage calculations using historical rates
- Visual indicators for wage changes (↑ increase / ↓ decrease)
- Daily breakdown showing:
  - Date, Status, Daily Wage, Wage Earned
- Summary statistics (total wages, present/absent days)

## 📋 Prerequisites

- Node.js 18+ 
- npm or yarn
- Supabase account and project

## 🛠️ Setup Instructions

### 1. Database Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run the SQL schema from the parent folder's `supabase.sql` file in your Supabase SQL editor
3. Get your Project URL and anon key from Project Settings → API

### 2. Application Setup

1. **Clone and install dependencies:**
   ```bash
   cd attendance-web
   npm install
   ```

2. **Configure environment variables:**
   ```bash
   cp .env.local.example .env.local
   ```

3. **Edit `.env.local` with your Supabase credentials:**
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key-here
   ```

4. **Run the development server:**
   ```bash
   npm run dev
   ```

5. **Open your browser:**
   Visit [http://localhost:3000](http://localhost:3000)

## 🚢 Deployment to Vercel

### Option 1: Deploy with Vercel CLI

1. **Install Vercel CLI:**
   ```bash
   npm install -g vercel
   ```

2. **Deploy:**
   ```bash
   vercel
   ```

3. **Add environment variables in Vercel Dashboard:**
   - Go to your project settings
   - Add `NEXT_PUBLIC_SUPABASE_URL`
   - Add `NEXT_PUBLIC_SUPABASE_ANON_KEY`

### Option 2: Deploy via GitHub

1. **Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin your-repo-url
   git push -u origin main
   ```

2. **Connect to Vercel:**
   - Go to [vercel.com](https://vercel.com)
   - Click "New Project"
   - Import your GitHub repository
   - Add environment variables:
     - `NEXT_PUBLIC_SUPABASE_URL`
     - `NEXT_PUBLIC_SUPABASE_ANON_KEY`
   - Click "Deploy"

3. **Your app is live!** 🎉

## 📁 Project Structure

```
attendance-web/
├── app/
│   ├── attendance/         # Daily tracker page
│   ├── employees/          # Employee management page
│   ├── payroll/           # Payroll dashboard page
│   ├── layout.tsx         # Root layout with navigation
│   ├── page.tsx           # Home (redirects to attendance)
│   └── globals.css        # Global styles
├── components/
│   └── Navigation.tsx     # Top navigation bar
├── lib/
│   ├── supabase.ts        # Supabase client & types
│   └── dateUtils.ts       # Date utility functions
├── .env.local.example     # Environment template
└── README.md             # This file
```

## 🎨 Tech Stack

- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript
- **Styling:** Tailwind CSS
- **UI Components:** Lucide React (icons)
- **Calendar:** react-calendar
- **Database:** Supabase (PostgreSQL)
- **Deployment:** Vercel
- **Date Utilities:** date-fns

## 🔒 Environment Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `NEXT_PUBLIC_SUPABASE_URL` | Your Supabase project URL | `https://xxx.supabase.co` |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Your Supabase anon public key | `eyJhbG...` |

⚠️ **Important:** Never commit `.env.local` to version control!

## 📊 Key Features Explained

### Historical Wage Tracking
When updating an employee's wage:
1. Current wage record is closed (sets `effective_to_date` to today)
2. New wage record is created starting tomorrow
3. All historical wages are preserved
4. Payroll calculations use the exact wage for each date

### Payroll Calculations
The system:
- Fetches attendance records for the selected period
- Looks up the applicable wage for each specific date
- Calculates wages based on Present days only
- Shows wage change indicators if wages changed during the period
- Provides detailed daily breakdowns

## 🧪 Testing

After setup:
1. Go to **Attendance** tab - mark attendance for employees
2. Go to **Employees** tab - add a new employee or update wages
3. Go to **Payroll** tab - view calculated wages with filters

## 🐛 Troubleshooting

### "Failed to load employees"
- Check your `.env.local` file has correct Supabase credentials
- Verify the SQL schema was executed in Supabase
- Check browser console for errors

### Calendar not styling correctly
- Run `npm install` to ensure all dependencies are installed
- Import the CSS in the component

### Build errors on Vercel
- Ensure environment variables are set in Vercel project settings
- Check that all TypeScript errors are resolved locally first

## 📝 Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server |
| `npm run build` | Build for production |
| `npm start` | Start production server |
| `npm run lint` | Run ESLint |

## 🌐 Production URL

After deploying to Vercel, your app will be available at:
`https://your-project-name.vercel.app`

You can also add a custom domain in Vercel settings.

## 📄 License

Copyright © 2024 Digiledger Solutions Ltd. All rights reserved.

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section
2. Review the database schema in `supabase.sql`
3. Check Supabase logs for database errors
4. Review browser console for frontend errors

---

**Built with ❤️ using Next.js and Supabase**
