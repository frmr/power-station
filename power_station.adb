package body power_station with SPARK_Mode is

   -------------------
   -- Start_Reactor --
   -------------------

   procedure Start_Reactor is
      Pressure, Temperature : Integer;
      Pressure_Warning, Pressure_Danger : Boolean;
      Temperature_Warning, Temperature_Danger : Boolean;
      Shutdown : Boolean;
   begin
      Pressure := 0;
      Temperature := 0;
      loop
         pragma Loop_Invariant (Status (Standard_Output) = Success and
                                Pressure >= 0 and
                                Pressure <= 3 and
                                Temperature >= 0 and
                                Temperature <= 3);
         
         Update_Reading("Pressure", Pressure, Shutdown);
         if Shutdown = True then
            Emergency_Shutdown;
            exit;
         end if;
         
         Update_Reading("Temperature", Temperature, Shutdown);
         if Shutdown = True then
            Emergency_Shutdown;
            exit;
         end if;

         Check_Reading(Pressure, Pressure_Warning, Pressure_Danger);
         Check_Reading(Temperature, Temperature_Warning, Temperature_Danger);

         if Pressure_Danger then
            Put_Line("Pressure at dangerous level.");
            Emergency_Shutdown;
            exit;
         end if;


         if Temperature_Danger then
            Put_Line("Temperature at dangerous level.");
            Emergency_Shutdown;
            exit;
         end if;



         if Pressure_Warning and Temperature_Warning then
            Put_Line("Pressure and temperature at warning levels.");
            Emergency_Shutdown;
            exit;
         elsif not Pressure_Warning and Temperature_Warning then
            Increase_Pressure;
         elsif Pressure_Warning and not Temperature_Warning then
            Decrease_Pressure;
         end if;

         pragma Assert(Shutdown = False and
                       Pressure_Danger = False and
                       Temperature_Danger = False and
                       not (Pressure_Warning = True and Temperature_Warning = True));

      end loop;
   end Start_Reactor;

   -------------------
   -- Check_Reading --
   -------------------

   procedure Check_Reading(Value : in Integer;
                           Warning, Danger : out Boolean) is
   begin
      if Value >= 2 then
         Warning := True;
         if Value = 3 then
            Danger := True;
         else
            Danger := False;
         end if;
      else
         Warning := False;
         Danger := False;
      end if;
   end Check_Reading;

   -----------------------
   -- Decrease_Pressure --
   -----------------------

   procedure Decrease_Pressure is
   begin
      Put_Line("Decreasing pressure.");
   end Decrease_Pressure;
   
   ------------------------
   -- Emergency_Shutdown --
   ------------------------

   procedure Emergency_Shutdown is
   begin
      Put_Line("SCRAM initiated.");
      Put_Line("Opening relief valve.");
   end Emergency_Shutdown;

   -----------------------
   -- Increase_Pressure --
   -----------------------

   procedure Increase_Pressure is
   begin
      Put_Line("Increasing pressure.");
   end Increase_Pressure;

   ---------------------
   -- Update_Reading  --
   ---------------------

   procedure Update_Reading(Name : in String;
                            Value : in out Integer;
                            Shutdown : out Boolean) is
      Input : String(1..2);
      Stop : Integer;
   begin
      Shutdown := False;
      
      Put("Current ");
      Put(Name);
      Put(": ");
      Put_Line(Integer'Image(Value));

      Put(Name);
      Put(" change: ");
      loop
         pragma Loop_Invariant  (Status (Standard_Output) = Success);
         Get_Line(Input,Stop);
         exit when not (Stop = 0);
      end loop;
      
      if Input(1) = '+' then
      
         if Value < 3 then
            Value := Value + 1;
         end if;
         
      elsif Input(1) = '-' then
      
         if Value > 0 then
            Value := Value - 1;
         end if;
            
      elsif Input(1) /= '=' then
         Put_Line("Invalid input. Requesting shutdown.");
         Shutdown := True;
      end if;

   end Update_Reading;

end power_station;
