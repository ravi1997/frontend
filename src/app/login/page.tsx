'use client';

import { useState } from 'react';
import Link from 'next/link';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from '@/components/ui/card';
import { useAuthStore } from '@/store/authStore';
import { Loader2, Mail, Smartphone } from 'lucide-react';

type LoginMethod = 'email' | 'mobile';

export default function LoginPage() {
  const { lastLoginMethod } = useAuthStore();
  const { login, isLoginLoading, loginError, generateOtp, isOtpLoading } = useAuth();

  const [loginMethod, setLoginMethod] = useState<LoginMethod>(
    lastLoginMethod || 'email'
  );
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [mobile, setMobile] = useState('');
  const [otp, setOtp] = useState('');
  const [otpSent, setOtpSent] = useState(false);
  const [countdown, setCountdown] = useState(0);

  const handleEmailLogin = (e: React.FormEvent) => {
    e.preventDefault();
    login({ email, password });
  };

  const handleSendOtp = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await generateOtp(mobile);
      setOtpSent(true);
      setCountdown(60);

      // Start countdown
      const interval = setInterval(() => {
        setCountdown((prev) => {
          if (prev <= 1) {
            clearInterval(interval);
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    } catch (error) {
      console.error('Failed to send OTP:', error);
    }
  };

  const handleOtpLogin = (e: React.FormEvent) => {
    e.preventDefault();
    login({ mobile, otp });
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900 p-4">
      <Card className="w-full max-w-md">
        <CardHeader className="space-y-1">
          <CardTitle className="text-2xl font-bold text-center">
            Welcome Back
          </CardTitle>
          <CardDescription className="text-center">
            Sign in to your account to continue
          </CardDescription>
        </CardHeader>

        <CardContent>
          {/* Login Method Toggle */}
          <div className="flex gap-2 mb-6">
            <Button
              type="button"
              variant={loginMethod === 'email' ? 'default' : 'outline'}
              className="flex-1"
              onClick={() => setLoginMethod('email')}
            >
              <Mail className="mr-2 h-4 w-4" />
              Email
            </Button>
            <Button
              type="button"
              variant={loginMethod === 'mobile' ? 'default' : 'outline'}
              className="flex-1"
              onClick={() => setLoginMethod('mobile')}
            >
              <Smartphone className="mr-2 h-4 w-4" />
              Mobile
            </Button>
          </div>

          {/* Email/Password Login */}
          {loginMethod === 'email' && (
            <form onSubmit={handleEmailLogin} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="email">Email</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="you@example.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                />
              </div>

              <div className="space-y-2">
                <div className="flex items-center justify-between">
                  <Label htmlFor="password">Password</Label>
                  <Link
                    href="/forgot-password"
                    className="text-sm text-primary hover:underline"
                  >
                    Forgot password?
                  </Link>
                </div>
                <Input
                  id="password"
                  type="password"
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                />
              </div>

              {loginError && (
                <p className="text-sm text-destructive">
                  {loginError.message || 'Invalid credentials'}
                </p>
              )}

              <Button
                type="submit"
                className="w-full"
                disabled={isLoginLoading}
              >
                {isLoginLoading && (
                  <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                )}
                Sign In
              </Button>
            </form>
          )}

          {/* Mobile/OTP Login */}
          {loginMethod === 'mobile' && (
            <div className="space-y-4">
              {!otpSent ? (
                <form onSubmit={handleSendOtp} className="space-y-4">
                  <div className="space-y-2">
                    <Label htmlFor="mobile">Mobile Number</Label>
                    <Input
                      id="mobile"
                      type="tel"
                      placeholder="9876543210"
                      pattern="[6-9][0-9]{9}"
                      value={mobile}
                      onChange={(e) => setMobile(e.target.value)}
                      required
                    />
                    <p className="text-xs text-muted-foreground">
                      Enter your 10-digit mobile number
                    </p>
                  </div>

                  <Button
                    type="submit"
                    className="w-full"
                    disabled={isOtpLoading}
                  >
                    {isOtpLoading && (
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    )}
                    Send OTP
                  </Button>
                </form>
              ) : (
                <form onSubmit={handleOtpLogin} className="space-y-4">
                  <div className="space-y-2">
                    <Label htmlFor="otp">Enter OTP</Label>
                    <Input
                      id="otp"
                      type="text"
                      placeholder="123456"
                      maxLength={6}
                      pattern="[0-9]{6}"
                      value={otp}
                      onChange={(e) => setOtp(e.target.value)}
                      required
                      autoFocus
                    />
                    <p className="text-xs text-muted-foreground">
                      OTP sent to {mobile}
                    </p>
                  </div>

                  {loginError && (
                    <p className="text-sm text-destructive">
                      {loginError.message || 'Invalid OTP'}
                    </p>
                  )}

                  <Button
                    type="submit"
                    className="w-full"
                    disabled={isLoginLoading || otp.length < 6}
                  >
                    {isLoginLoading && (
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    )}
                    Verify & Sign In
                  </Button>

                  <Button
                    type="button"
                    variant="ghost"
                    className="w-full"
                    onClick={() => {
                      setOtpSent(false);
                      setOtp('');
                    }}
                  >
                    Change Number
                  </Button>

                  {countdown > 0 ? (
                    <p className="text-sm text-center text-muted-foreground">
                      Resend OTP in {countdown}s
                    </p>
                  ) : (
                    <Button
                      type="button"
                      variant="link"
                      className="w-full"
                      onClick={handleSendOtp}
                      disabled={isOtpLoading}
                    >
                      Resend OTP
                    </Button>
                  )}
                </form>
              )}
            </div>
          )}
        </CardContent>

        <CardFooter className="flex flex-col space-y-4">
          <div className="text-sm text-center text-muted-foreground">
            Don&apos;t have an account?{' '}
            <Link href="/register" className="text-primary hover:underline">
              Sign up
            </Link>
          </div>
        </CardFooter>
      </Card>
    </div>
  );
}
