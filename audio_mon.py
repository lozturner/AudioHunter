import sys
import threading
import time
import psutil
import customtkinter as ctk
import win32gui
import win32process
import win32con
import win32api
from pycaw.pycaw import AudioUtilities, IAudioMeterInformation, ISimpleAudioVolume

# --- Configuration ---
REFRESH_RATE_MS = 100
AUDIO_THRESHOLD = 0.001  # Very low threshold to catch any sound
THEME_COLOR = "blue"

ctk.set_appearance_mode("Dark")
ctk.set_default_color_theme(THEME_COLOR)

# --- High Priority ---
try:
      pid = win32process.GetCurrentProcessId()
      handle = win32api.OpenProcess(win32con.PROCESS_ALL_ACCESS, True, pid)
      win32process.SetPriorityClass(handle, win32process.HIGH_PRIORITY_CLASS)
except Exception as e:
      print(f"Failed to set high priority: {e}")

class AudioSessionWrapper:
      def __init__(self, session):
                self.session = session
                self.process = session.Process
                self.pid = self.process.pid if self.process else 0
                self.name = self.process.name() if self.process else "System Sounds"

        # Audio Interfaces
                self._meter = None
                self._volume = None

    @property
    def meter(self):
              if not self._meter:
                            self._meter = self.session._ctl.QueryInterface(IAudioMeterInformation)
                        return self._meter

    @property
    def volume(self):
              if not self._volume:
                            self._volume = self.session._ctl.QueryInterface(ISimpleAu
