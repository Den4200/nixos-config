{ ... }:
{
  den.aspects.dennis.provides.shiro.homeManager =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      llamaCpp = pkgs.llama-cpp.override {
        cudaSupport = true;
        blasSupport = true;
      };

      modelFile = "${config.xdg.dataHome}/llama-server/models/Qwen3-Coder-Next-UD-Q4_K_XL.gguf";

      llamaSwapConfig = (pkgs.formats.yaml { }).generate "llama-swap-config.yaml" {
        healthCheckTimeout = 60;
        models = {
          "qwen3-coder-next-ud-q4_k_xl" = {
            cmd = ''
              ${llamaCpp}/bin/llama-server
              --port ''${PORT}
              --host 127.0.0.1
              --model ${modelFile}
              --temp 1.0
              --top-p 0.95
              --min-p 0.01
              --top-k 40
              --ctx-size 65536
              --fit on
              --fit-ctx 65536
              --fit-target 128
              --seed 3407
              --threads 16
              --batch-size 2048
              --ubatch-size 512
              --cache-type-k q8_0
              --cache-type-v q8_0
              --flash-attn on
              --no-mmap
              --mlock
              --jinja
            '';
            proxy = "http://127.0.0.1:\${PORT}";
            ttl = 300;
          };
        };
      };
    in
    {
      home.packages = [
        llamaCpp
        pkgs.llama-swap
      ];

      python.extraPackages = with pkgs.python3Packages; [
        huggingface-hub
        hf-transfer
      ];

      home.sessionVariables.HF_HUB_ENABLE_HF_TRANSFER = "1";

      programs.opencode = {
        enable = true;
        settings = {
          autoupdate = "notify";
          provider = {
            "llama.cpp" = {
              npm = "@ai-sdk/openai-compatible";
              name = "llama-server (local)";
              options = {
                baseURL = "http://127.0.0.1:9292/v1";
              };
              models = {
                qwen3-coder-next-ud-q4_k_xl = {
                  name = "Qwen-3-Coder-Next-UD-Q4_K_XL";
                  limit = {
                    context = 65536;
                    input = 65536;
                    output = 65536;
                  };
                };
              };
            };
          };
          formatter = true;
          lsp = true;
          permission = {
            edit = "ask";
            bash = "ask";
          };
        };
      };

      # TODO: add a job to auto pull model from Hugging Face if it doesn't exist locally
      systemd.user.services.llama-swap = {
        Unit = {
          Description = "llama-swap model proxy";
          After = [ "network.target" ];
        };
        Service = {
          ExecStart = "${lib.getExe pkgs.llama-swap} --config ${llamaSwapConfig} --listen 127.0.0.1:9292";
          Restart = "on-failure";
          RestartSec = "5s";
          Environment = "LD_LIBRARY_PATH=/run/opengl-driver/lib:/run/opengl-driver-32/lib";
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    };
}
