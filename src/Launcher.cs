// Small Windows wrapper: starts Launcher\RR_Launcher.ps1 with PowerShell (no console window).
// Build (Windows):  C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe /target:winexe /out:"Redneck Rampage Launcher.exe" src\Launcher.cs
// Build (Mono):     mcs -target:winexe -r:System.Windows.Forms.dll -out:"Redneck Rampage Launcher.exe" src/Launcher.cs
using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
[assembly: System.Reflection.AssemblyTitle("Redneck Rampage Launcher")]
[assembly: System.Reflection.AssemblyProduct("Redneck Rampage Launcher")]
[assembly: System.Reflection.AssemblyVersion("1.1.0.0")]
class Program {
  [STAThread]
  static void Main() {
    string dir = AppDomain.CurrentDomain.BaseDirectory;
    string ps1 = Path.Combine(dir, "Launcher", "RR_Launcher.ps1");
    if (!File.Exists(ps1)) { MessageBox.Show("File not found: Launcher\\RR_Launcher.ps1", "Redneck Rampage Launcher"); return; }
    try {
      ProcessStartInfo si = new ProcessStartInfo("powershell.exe",
        "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -STA -File \"" + ps1 + "\"");
      si.UseShellExecute = false; si.CreateNoWindow = true; si.WorkingDirectory = dir;
      Process.Start(si);
    } catch (Exception e) { MessageBox.Show("Could not start PowerShell.\n" + e.Message, "Redneck Rampage Launcher"); }
  }
}
