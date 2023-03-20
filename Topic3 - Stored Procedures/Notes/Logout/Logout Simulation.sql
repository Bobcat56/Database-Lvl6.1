use dp2;
go

create or alter procedure topic3.spLogout
	(@username nvarchar(45))
as begin
	set nocount on;

	if(topic3.doesUserExist(@username) = 0)
	begin
		execute topic3.auditSessionLogin 0, 0, null, 'User does not exist!', @username;
		return;
	end

	declare @sessionId bigint = topic3.isUserLoggedIn(@username);
	if(@sessionId is null)
	begin
		execute topic3.auditSessionLogin 0, 0, null, 'User is not logged in!', @username;
		return;
	end

	insert into topic3.sessionLog
		(entryDate, isLogin, sessionId, accountId)
	values
		(sysdatetimeoffset(), 0, @sessionId,
			(select accountId
			 from topic3.userAccount
			 where accountUsername = @username)
		);

	execute topic3.auditSessionLogin 0, 1, @sessionId, 'User has been logged out successfully!', @username;
end;
go

exec topic3.spLogout 'alan'; -- Attempt to logout inexistent user.
exec topic3.spLogout 'tonyz'; -- Attempt to logout an existent user who is not logged in.
exec topic3.spLogout 'joeb'; -- Attempt to logout a logged in user.

select * from topic3.sessionAudit;
select * from topic3.sessionLog;