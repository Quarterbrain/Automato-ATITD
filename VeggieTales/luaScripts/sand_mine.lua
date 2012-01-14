--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

xyWindowSize = srGetWindowSize();
imgWork1 = "WorkThisMine.png";
imgWork2 = "WorkThisMine2.png";
imgRepair1 = "RepairThisMine1.png";
imgRepair2 = "RepairThisMine2.png";
imgStrBlack = "Strength-Black.png";
imgPerBlack = "Perception-Black.png";
delay_time = 10;

function doit()
	local mine_count=0;
	askForWindow("Make sure the Skills window is visible and Sand Mine window is pinned.");
	local end_red;
	local failures=0;
	local just_repaired=nil;
	while 1 do
		checkBreak();
		lsSleep(delay_time);
		checkBreak();
		if str_black and per_black then
			statusScreen("(" .. mine_count .. " pulls) Mining...");
		else
			statusScreen("(" .. mine_count .. " pulls) Waiting (STR or PER is not black)");
		end
		srReadScreen();
		str_black = srFindImage(imgStrBlack);
		per_black = srFindImage(imgPerBlack);
		if str_black and per_black then
			local mine = srFindImage(imgWork1, 4000);
			if not mine then
				mine = srFindImage(imgWork2, 4000);
			end
			if mine then
				srClickMouseNoMove(mine[0]+5, mine[1], 0);
				mine_count = mine_count + 1;
				failures = 0;
				just_repaired = nil;
			else
				repair = srFindImage(imgRepair1, 4000);
				if not repair then
					repair = srFindImage(imgRepair2, 4000);
				end
				if repair then
					if just_repaired then
						error ("Repaired once, but still broken? (did " .. mine_count .. " pulls)");
					else
						srClickMouseNoMove(repair[0]+5, repair[1], 0);
						lsSleep(500);
						just_repaired = 1;
					end
				end
				failures = failures + 1;
				if (failures == 50) then
					error ("Could not find Work This Mine button (did " .. mine_count .. " pulls)");
				else
					statusScreen("Failed to find Work This Mine button...");
					lsSleep(1000);
				end
			end
		end
	end
end
