			declare @kill varchar(8000) = '';
			select @kill=@kill+'kill '+convert(varchar(5),spid)+';'
			    from master..sysprocesses 
			where dbid=db_id('MyDB');
			exec (@kill);
