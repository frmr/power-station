with SPARK.Text_IO; use SPARK.Text_IO;

package power_station with SPARK_Mode is
   procedure Start_Reactor with
     Global  => (In_Out => (Standard_Input, Standard_Output)),
     Depends => (Standard_Output => (Standard_Input, Standard_Output),
                 Standard_Input  => (Standard_Input)),
     Pre     => Status (Standard_Output) = Success,
     Post    => Status (Standard_Output) = Success;

private

   procedure Check_Reading(Value : in Integer; 
                           Warning, Danger : out Boolean) with
     Depends => (Warning => Value,
                 Danger  => Value),
     Pre     => (Value >= 0 and Value <= 3),
     Post    => ((if Value >= 2 then Warning = True) and
                 (if Value < 2 then Warning = False) and     
                 (if Value = 3 then Danger = True) and
                 (if Value < 3 then Danger = False));
   
   procedure Decrease_Pressure with
     Global  => (In_Out => (Standard_Output)),
     Depends => (Standard_Output => (Standard_Output)),
     Pre     => Status (Standard_Output) = Success,
     Post    => Status (Standard_Output) = Success;
       
   
   procedure Emergency_Shutdown with
     Global  => (In_Out => (Standard_Output)),
     Depends => (Standard_Output => (Standard_Output)),
     Pre     => Status (Standard_Output) = Success,
     Post    => Status (Standard_Output) = Success;
   
   procedure Increase_Pressure with
     Global  => (In_Out => (Standard_Output)),
     Depends => (Standard_Output => (Standard_Output)),
     Pre     => Status (Standard_Output) = Success,
     Post    => Status (Standard_Output) = Success;
   
   procedure Update_Reading(Name : in String;
                            Value : in out Integer;
                            Shutdown : out Boolean) with
     Global  => (In_Out => (Standard_Input, Standard_Output)),
     Depends => (Standard_Output => (Standard_Input, Standard_Output, Name, Value),
                 Standard_Input  => (Standard_Input),
                 Value           => (Standard_Input, Value),
                 Shutdown        => (Standard_Input)),
     Pre     => (Status (Standard_Output) = Success and
                 Value >= 0 and
                 Value <= 3),
     Post    => (Status (Standard_Output) = Success and
                (if Value'Old = 0 then (Value = 0 or Value = 1)) and
                (if Value'Old = 1 then (Value = 0 or Value = 1 or Value = 2)) and
                (if Value'Old = 2 then (Value = 1 or Value = 2 or Value = 3)) and
                (if Value'Old = 3 then (Value = 2 or Value = 3)));

end power_station;
