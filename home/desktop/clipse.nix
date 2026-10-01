{
  services.clipse = {
    enable = true;
    settings = {
      imageDisplay.type = "kitty";
      keyBindings = {
        up = "k,up";
        down = "j,down";
        prevPage = "h,left";
        nextPage = "l,right";
        quit = "q,esc";
        remove = "d";
      };
    };
    # Tokyo Night based (upstream: .github/.resources/themes/tokyo_night.json)
    theme = {
      useCustom = true;
      TitleFore = "#C0CAF5";
      TitleBack = "#1A1B26";
      TitleInfo = "#C0CAF5";
      NormalTitle = "#7AA2F7";
      DimmedTitle = "#3B4261";
      SelectedTitle = "#7DCFFF";
      NormalDesc = "#A9B1D6";
      DimmedDesc = "#3B4261";
      SelectedDesc = "#A9B1D6"; # upstream: #7AA2F7
      StatusMsg = "#BB9AF7";
      PinIndicatorColor = "#FF9E64";
      SelectedBorder = "#7AA2F7";
      SelectedDescBorder = "#7DCFFF";
      FilteredMatch = "#9ECE6A";
      FilterPrompt = "#E0AF68";
      FilterInfo = "#C0CAF5";
      FilterText = "#C0CAF5";
      FilterCursor = "#F7768E";
      HelpKey = "#7AA2F7";
      HelpDesc = "#C0CAF5";
      PageActiveDot = "#9ECE6A";
      PageInactiveDot = "#3B4261";
      DividerDot = "#F7768E";
      PreviewedText = "#C0CAF5";
      PreviewBorder = "#BB9AF7";
    };
  };

  systemd.user.services.clipse.Service.UMask = "0077";
}
