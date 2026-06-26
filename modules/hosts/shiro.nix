{ inputs, ... }:
{
  den.aspects.shiro = {
    nixos =
      {
        config,
        lib,
        pkgs,
        modulesPath,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/scan/not-detected.nix")
        ];

        # Hardware / kernel
        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];

        # Boot
        boot.loader.systemd-boot.enable = true;
        boot.loader.efi.canTouchEfiVariables = true;

        # Filesystems
        fileSystems."/" = {
          device = "/dev/disk/by-label/NIXROOT";
          fsType = "btrfs";
        };

        fileSystems."/home" = {
          device = "/dev/disk/by-label/NIXROOT";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };

        fileSystems."/nix" = {
          device = "/dev/disk/by-label/NIXROOT";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-label/NIXBOOT";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };

        swapDevices = [ ];

        # Hardware
        hardware = {
          bluetooth.enable = true;
          cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
          graphics.enable = true;
          nvidia = {
            modesetting.enable = true;
            powerManagement = {
              enable = false;
              finegrained = false;
            };
            open = true;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
          };
        };

        # Nix settings
        nix = {
          gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 30d";
          };
          optimise = {
            automatic = true;
            dates = "weekly";
          };
          settings.experimental-features = [
            "nix-command"
            "flakes"
          ];
        };

        nixpkgs.config.allowUnfree = true;

        # Networking
        networking = {
          hostName = "shiro";
          networkmanager.enable = true;
        };

        # Locale
        time.timeZone = "America/New_York";

        i18n = {
          defaultLocale = "en_US.UTF-8";
          extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
          };
        };

        # Display / Desktop
        services.xserver.enable = true;
        services.xserver.videoDrivers = [ "nvidia" ];
        services.xserver.xkb = {
          layout = "us";
          variant = "";
        };

        # Secret service (for VS Code, browsers, etc.)
        services.gnome.gnome-keyring.enable = true;
        security.pam.services.greetd.enableGnomeKeyring = true;
        programs.seahorse.enable = true;

        # Login manager (greetd + regreet via niri)
        programs.regreet = {
          enable = true;
          # Pin to regreet 0.3.0 (0.4.0 crashes due to GStreamer init failure)
          settings = {
            background = {
              path = "${../../resources/wallpaper.jpeg}";
              fit = "Cover";
            };
          };
        };

        services.greetd.settings.default_session = {
          command = lib.mkForce (
            let
              niri = lib.getExe pkgs.niri-unstable;
              niriGreeterConfig = pkgs.writeText "niri-greeter-config.kdl" ''
                spawn-sh-at-startup "${lib.getExe config.programs.regreet.package}; ${niri} msg action quit --skip-confirmation"

                hotkey-overlay {
                    skip-at-startup
                }

                output "DP-3" {
                    mode "3840x2160@239.990"
                    scale 1
                    focus-at-startup
                    variable-refresh-rate
                }

                output "DP-2" {
                    off
                }
              '';
            in
            "${niri} --config ${niriGreeterConfig}"
          );
          user = "greeter";
        };

        # Audio
        services.pulseaudio.enable = false;
        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };

        # Services
        services.dbus.implementation = "broker";
        services.printing.enable = true;
        programs.firefox.enable = true;

        environment.systemPackages = with pkgs; [
          # Required for file chooser w/ xdg-desktop-portal-gnome that is installed with niri
          nautilus
        ];
      };

    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ ];
      };
  };
}
