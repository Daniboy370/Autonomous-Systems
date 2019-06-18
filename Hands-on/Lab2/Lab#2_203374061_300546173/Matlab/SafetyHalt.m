function [] = SafetyHalt(VelPub)
%SafetyHalt Safely halts the Pioneer
vCmd_msg = rosmessage(VelPub);  % Create vel. cmd. message
vCmd_msg.Linear.X = 0;
vCmd_msg.Linear.Y = 0;
vCmd_msg.Linear.Z = 0;
vCmd_msg.Angular.X = 0;
vCmd_msg.Angular.Y = 0;
vCmd_msg.Angular.Z = 0;
send(VelPub,vCmd_msg)
end

