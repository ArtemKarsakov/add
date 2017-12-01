

#Использовать v8runner
#Использовать cmdline
#Использовать logos
#Использовать 1commands
#Использовать json

Перем ВозможныеКоманды;
Перем Лог;
Перем ЭтоWindows;
Перем Бинарники1СХранятсяРядомСИсходникам;

Процедура ИнициализацияОкружения()

	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоWindows = Найти(ВРег(СистемнаяИнформация.ВерсияОС), "WINDOWS") > 0;

	Лог = Логирование.ПолучитьЛог("oscript.app.vanessa-init");
	Лог.УстановитьРаскладку(ЭтотОбъект);

	ВозможныеКоманды = Новый Структура("file, server", "file", "server");
	
	ПарсерАргументовКоманднойСтроки = Новый ПарсерАргументовКоманднойСтроки();
	
	ПарсерАргументовКоманднойСтроки.ДобавитьПараметрФлаг("--useBuildFolderForBinaries", 
		"Использовать каталог ""./build"" для работы с бинарными файлами (внешние обработки/отчеты)
		|В конфигураторе работаем с файлами из этого каталога
		|А в исходники попадают файлы из корневого каталога", 
		Истина);

	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметр("--v8version", "Версия платформы", Истина);
	
	ОписаниеКоманды = ПарсерАргументовКоманднойСтроки.ОписаниеКоманды(ВозможныеКоманды.file);
	ПарсерАргументовКоманднойСтроки.ДобавитьКоманду(ОписаниеКоманды);

	ОписаниеКоманды1 = ПарсерАргументовКоманднойСтроки.ОписаниеКоманды(ВозможныеКоманды.server);
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--srvr", "Сервер 1С" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--srvrport", "Порт сервера 1С" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--srvrproto", "Протокол, TCP" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--ref", "Имя базы на сервере 1C" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--dbms", "Тип базы данных [MSSQLServer, PostgreSQL, IBMDB2, OracleDatabase]" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--dbsrvr", "Сервера SQL" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--dbname", "Имя базы на сервере SQL, по умолчанию равно --ref" );
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--dbuid", "Имя пользователя базы данных");
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--dbpwd", "Пароль пользователя");
	// SQLYOffs - нафиг этот прошлый век, такой параметр неправильным даже поддерживать не будем. 
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--locale", "язык (страна)");
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--crsqldb", "создать базу в случаии ее ее отсутствия [Y|N], по умолчанию Y");
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--schjobdn", "апретить выполнение регламентных созданий (Y/N). Значение по умолчанию — Y");
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--susr", "имя администратора кластера");
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--spwd", "пароль администратора кластера");
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--licdstr", "разрешить получение клиентских лицензий через сервер Y|N, default Y");
	//LicDstr
	//Zn
	ПарсерАргументовКоманднойСтроки.ДобавитьИменованныйПараметрКоманды(ОписаниеКоманды1, "--zn", "Разделители. ");
	ПарсерАргументовКоманднойСтроки.ДобавитьКоманду(ОписаниеКоманды1);

	Аргументы = ПарсерАргументовКоманднойСтроки.РазобратьКоманду(АргументыКоманднойСтроки);

	Если Аргументы = Неопределено Тогда
		Аргументы = Новый Структура("Команда, ЗначенияПараметров", "file", Новый Соответствие);
	КонецЕсли;

	ИспользоватьКаталогБилдДляБинарников = Аргументы.ЗначенияПараметров["--useBuildFolderForBinaries"];
	Если ИспользоватьКаталогБилдДляБинарников = Неопределено Тогда
		ИспользоватьКаталогБилдДляБинарников = Ложь;
	КонецЕсли;
	Бинарники1СХранятсяРядомСИсходникам = Не ИспользоватьКаталогБилдДляБинарников;

	Лог.Информация("Указан вариант хранения бинарных внешних файлов (epf,erf) %1", 
		?(Бинарники1СХранятсяРядомСИсходникам, "- в корневом каталоге", "- в каталоге ./build"));
	
	ВерсияПлатформы = 	?(Аргументы.ЗначенияПараметров["--v8version"] = Неопределено, 
						"8.3.10",
						Аргументы.ЗначенияПараметров["--v8version"]
						);
	СтрокаПодключения = "";
	Лог.Информация("Получили команду %1", Аргументы.Команда);
	Лог.Информация("Версия платформы %1", ВерсияПлатформы);

	ИмяКаталогаСборки = ?(Бинарники1СХранятсяРядомСИсходникам, "", "build");
	КаталогСборки = ?(Бинарники1СХранятсяРядомСИсходникам, "", СтрШаблон("./%1/", ИмяКаталогаСборки));

	ОкончаниеИмениФайлаНастройки = ?(Бинарники1СХранятсяРядомСИсходникам, "", СтрШаблон(".%1", ИмяКаталогаСборки));
	ИмяФайлаНастройки = СтрШаблон("./tools/JSON/env.json.%1%2", Аргументы.Команда, ОкончаниеИмениФайлаНастройки);

	Лог.Информация("Скопировали %1 в env.json", ИмяФайлаНастройки);
	КопироватьФайл(СтрШаблон("%1", ИмяФайлаНастройки), "./env.json");
	
	Если Аргументы.Команда = ВозможныеКоманды.file Тогда
		
		Лог.Информация("Создание основной файловой базы - runner init-dev");
		
		СтрокаПодключения = "/F./build/ib";

	ИначеЕсли Аргументы.Команда = ВозможныеКоманды.server Тогда
		Лог.Информация("Создание основной базы сервер - runner init-dev");
		
		ЗапуститьСозданиеСервернойБазы(Аргументы.ЗначенияПараметров);
		
		СтрокаПодключения = СтрШаблон("/S%1:%2/%3", Аргументы.ЗначенияПараметров["--srvr"], 
									Строка(Аргументы.ЗначенияПараметров["--srvrport"]),
									Строка(Аргументы.ЗначенияПараметров["--ref"]));
		
	КонецЕсли;
	
	ЗаписатьВНастройкиПараметры(СтрокаПодключения, ВерсияПлатформы);

	СтрокаВыполнения = "runner init-dev --src ./lib/CF/83NoSync --ibconnection " + СтрокаПодключения;
	ИсполнитьКоманду(СтрокаВыполнения);

	СтрокаВыполнения = "runner init-dev --dev --src ./lib/CF/83NoSync --ibconnection /F./build/ibservice --nocacheuse";
	ИсполнитьКоманду(СтрокаВыполнения);

	Если НЕ Новый Файл("./build/1Cv8.cf").Существует() Тогда
		ИсполнитьКоманду("runner unload ./build/1Cv8.cf --ibconnection /F./build/ibservice");
		// ИсполнитьКоманду("runner compile");
	Иначе
		Лог.Информация("./build/1Cv8.cf существует, пропускаем компиляцию");
	КонецЕсли;

	// Лог.Информация("deployka loadcfg " + СтрокаПодключения);
	// СтрокаЗапуска = "deployka loadcfg " + СтрокаПодключения + " ./build/ /mode -load"+ " -v8version " + ВерсияПлатформы;
	// ИсполнитьКоманду(СтрокаЗапуска);

	// СтрокаЗапуска = "deployka loadcfg /F./build/ibservice ./build/ /mode -load" + " -v8version " + ВерсияПлатформы;
	// ИсполнитьКоманду(СтрокаЗапуска);

	УстановитьПеременнуюСреды("RUNNER_DBUSER", " ");
	УстановитьПеременнуюСреды("RUNNER_DBPWD", " ");

	СтрокаЗапуска = "runner updatedb --uccode test";
	ИсполнитьКоманду(СтрокаЗапуска);

	Если Не Бинарники1СХранятсяРядомСИсходникам Тогда
		
		//СоздатьКаталог("./build/epf");
		СоздатьКаталог(СтрШаблон("%1features", КаталогСборки));
		СоздатьКаталог(СтрШаблон("%1tools", КаталогСборки));
		СоздатьКаталог(СтрШаблон("%1lib", КаталогСборки));
		СоздатьКаталог(СтрШаблон("%1plugins", КаталогСборки));
		СоздатьКаталог(СтрШаблон("%1vendor", КаталогСборки));
		СоздатьКаталог(СтрШаблон("%1lib/TemplateEpf", КаталогСборки));

	КонецЕсли;
	
	КлючиКомандыСборки = ?(Бинарники1СХранятсяРядомСИсходникам, "", "--useBuildFolderForBinaries");
	
	СтрокаЗапуска = СтрШаблон("opm run cepf %1", КлючиКомандыСборки);
	ИсполнитьКоманду(СтрокаЗапуска);

	СтрокаЗапуска = СтрШаблон("oscript ./tools/runner.os compileepf ./tools %1tools --ibname /F./build/ibservice", КаталогСборки);
	ИсполнитьКоманду(СтрокаЗапуска);

	СтрокаЗапуска = СтрШаблон("oscript ./tools/runner.os compileepf ./lib %1lib --ibname /F./build/ibservice", КаталогСборки);
	ИсполнитьКоманду(СтрокаЗапуска);

	Если НЕ Бинарники1СХранятсяРядомСИсходникам Тогда
		СтрокаЗапуска = СтрШаблон("oscript ./tools/runner.os compileepf ./lib/TemplateEpf %1lib/TemplateEpf --onlycopy --ibname /F./build/ibservice", КаталогСборки);
		ИсполнитьКоманду(СтрокаЗапуска);
		
		СтрокаЗапуска = СтрШаблон("oscript ./tools/runner.os compileepf ./lib/TemplateEpfUF %1lib/TemplateEpfUF --onlycopy --ibname /F./build/ibservice", КаталогСборки);
		ИсполнитьКоманду(СтрокаЗапуска);
	КонецЕсли;

	СтрокаЗапуска = СтрШаблон("runner run --command VBParams=./tools/epf/init.json --execute %1tools/epf/init.epf", КаталогСборки);
	ИсполнитьКоманду(СтрокаЗапуска);
	
	Лог.Информация("ВСЕ!");
КонецПроцедуры

Процедура ЗаписатьВНастройкиПараметры(СтрокаПодключения, ВерсияПлатформы)
	
	Чтение = Новый ЧтениеТекста("./env.json");
	JsonСтрока  = Чтение.Прочитать();
	Чтение.Закрыть();
	Чтение = Неопределено;
	ПарсерJSON  = Новый ПарсерJSON();
	Результат   = ПарсерJSON.ПрочитатьJSON(JsonСтрока);
	Если Результат.Получить("default") <> Неопределено Тогда
		//Результат["default"]
		Результат["default"].Вставить("--ibconnection", СтрокаПодключения );
		Результат["default"].Вставить("--v8version", ВерсияПлатформы );
		
		JsonСтрока = ПарсерJSON.ЗаписатьJSON(Результат);
		Запись = Новый ЗаписьТекста;
		Запись.Открыть("./env.json");
		Запись.Записать(JsonСтрока);
		Запись.Закрыть();
	
	КонецЕсли;

КонецПроцедуры

Процедура ЗапуститьСозданиеСервернойБазы(Параметры)
		Команда = Новый Команда;

		СИ = Новый СистемнаяИнформация;
		СоответствиеПеременных = Новый Соответствие();
		СоответствиеПеременных.Вставить("RUNNER_srvr", "--srvr");
		СоответствиеПеременных.Вставить("RUNNER_srvrport", "--srvrport");
		СоответствиеПеременных.Вставить("RUNNER_srvrproto", "--srvrproto");
		СоответствиеПеременных.Вставить("RUNNER_ref", "--ref");
		СоответствиеПеременных.Вставить("RUNNER_dbms", "--dbms");
		СоответствиеПеременных.Вставить("RUNNER_dbsrvr", "--dbsrvr");
		СоответствиеПеременных.Вставить("RUNNER_dbname", "--dbname");
		СоответствиеПеременных.Вставить("RUNNER_dbuid", "--dbuid");
		СоответствиеПеременных.Вставить("RUNNER_dbpwd", "--dbpwd");
		СоответствиеПеременных.Вставить("RUNNER_locale", "--locale");
		СоответствиеПеременных.Вставить("RUNNER_crsqldb", "--crsqldb");
		СоответствиеПеременных.Вставить("RUNNER_schjobdn", "--schjobdn");
		СоответствиеПеременных.Вставить("RUNNER_susr", "--susr");
		СоответствиеПеременных.Вставить("RUNNER_spwd", "--spwd");
		СоответствиеПеременных.Вставить("RUNNER_licdstr", "--licdstr");
		СоответствиеПеременных.Вставить("RUNNER_zn", "--zn");
		
		ПодключитьСценарий(ОбъединитьПути(ТекущийСценарий().Каталог, "..", "tools", "runner.os"), "runner");
		runner = Новый runner();
		runner.ДополнитьАргументыИзПеременныхОкружения(Параметры, СоответствиеПеременных);

		Параметры["--srvrport"] = ЗначениеПоУмолчанию(Параметры["--srvrport"], Строка(1541));
		Параметры["--srvrproto"] = ЗначениеПоУмолчанию(Параметры["--srvrproto"], "tcp://");
		Параметры["--dbms"] = ЗначениеПоУмолчанию(Параметры["--dbms"], "PostgreSQL");
		Параметры["--locale"] = ЗначениеПоУмолчанию(Параметры["--locale"], "ru");
		Параметры["--dbname"] = ЗначениеПоУмолчанию(Параметры["--dbname"], Параметры["--ref"]);
		Параметры["--crsqldb"] = ЗначениеПоУмолчанию(Параметры["--crsqldb"], "Y");
		Параметры["--licdstr"] = ЗначениеПоУмолчанию(Параметры["--licdstr"], "Y");
		Параметры["--schjobdn"] = ЗначениеПоУмолчанию(Параметры["--schjobdn"], "N");

		Параметры["--srvr"] = ?(
			ЗначениеЗаполнено(ПолучитьПеременнуюСреды("SERVERONEC")),
			ПолучитьПеременнуюСреды("SERVERONEC"),
			Параметры["--srvr"]);
		Параметры["--ref"] = ?(
			ЗначениеЗаполнено(ПолучитьПеременнуюСреды("SERVERBASE")),
			ПолучитьПеременнуюСреды("SERVERBASE"),
			Параметры["--ref"]);
		Параметры["--ref"] = ?(
			ЗначениеЗаполнено(ПолучитьПеременнуюСреды("SERVERBASE")),
			ПолучитьПеременнуюСреды("SERVERBASE"),
			Параметры["--ref"]);
		Параметры["--dbsrvr"] = ?(
			ЗначениеЗаполнено(ПолучитьПеременнуюСреды("SERVERPOSTGRES")),
			ПолучитьПеременнуюСреды("SERVERPOSTGRES"),
			Параметры["--dbsrvr"]);
		
		Параметры["--dbuid"] = ?(
			ЗначениеЗаполнено(ПолучитьПеременнуюСреды("SERVERPOSTGRESUSER")),
			ПолучитьПеременнуюСреды("SERVERPOSTGRESUSER"),
			Параметры["--dbuid"]);
		
		Параметры["--dbpwd"] = ?(
			ЗначениеЗаполнено(ПолучитьПеременнуюСреды("SERVERPOSTGRESPASSWD")),
			ПолучитьПеременнуюСреды("SERVERPOSTGRESPASSWD"),
			Параметры["--dbpwd"]);

		Параметры["--srvr"] = ЗначениеПоУмолчанию(Параметры["--srvr"], "serveronec.service.consul");
		Параметры["--srvr"] = ЗначениеПоУмолчанию(Параметры["--srvr"], "dev");
		Параметры["--dbsrvr"] = ЗначениеПоУмолчанию(Параметры["--dbsrvr"], "postgres");
		Параметры["--dbuid"] = ЗначениеПоУмолчанию(Параметры["--dbuid"], "postgres");
		Параметры["--dbpwd"] = ЗначениеПоУмолчанию(Параметры["--dbpwd"], "postgres");

		СтрокаПодключенияСервера = "" + Параметры["--srvrproto"] + Параметры["--srvr"] + ":" + Строка(Параметры["--srvrport"]);
		СтрокаСозданияБазы = "";
		
		СтрокаСозданияБазы = СтрШаблон("Srvr=%1;Ref=%2", 
				СтрокаПодключенияСервера,
				Параметры["--ref"]
				);
		СтрокаСозданияБазы = СтрШаблон("%1;DBMS=%2", 
				СтрокаСозданияБазы, 
				Параметры["--dbms"]
			);
		СтрокаСозданияБазы = СтрШаблон("%1;DBSrvr=%2;DB=%3",
			СтрокаСозданияБазы,
			Параметры["--dbsrvr"],
			Параметры["--dbname"]);
	
		Если ЗначениеЗаполнено(Параметры["--dbuid"]) Тогда 
			СтрокаСозданияБазы = СтрШаблон("%1;DBUID=%2", СтрокаСозданияБазы, Параметры["--dbuid"]);
			Если ЗначениеЗаполнено(Параметры["--dbpwd"]) Тогда
				СтрокаСозданияБазы = СтрШаблон("%1;DBPwd=%2", СтрокаСозданияБазы, Параметры["--dbpwd"]);
			КонецЕсли;
		КонецЕсли;

		Если Параметры["--dbms"] = "MSSQLServer" Тогда
			СтрокаСозданияБазы = СтрШаблон("%1;SQLYOffs=%2", СтрокаСозданияБазы, "2000");
		КонецЕсли;

		СтрокаСозданияБазы = СтрШаблон("%1;Locale=%2", СтрокаСозданияБазы, Параметры["--locale"]);
		СтрокаСозданияБазы = СтрШаблон("%1;CrSQLDB=Y", СтрокаСозданияБазы);
		СтрокаСозданияБазы = СтрШаблон("%1;SchJobDn=%2", СтрокаСозданияБазы, Параметры["--schjobdn"]);
		Если ЗначениеЗаполнено(Параметры["--susr"]) Тогда 
			СтрокаСозданияБазы = СтрШаблон("%1;SUsr=%2", СтрокаСозданияБазы, Параметры["--susr"]);
			Если ЗначениеЗаполнено(Параметры["--spwd"]) Тогда
				СтрокаСозданияБазы = СтрШаблон("%1;SPwd=%2", СтрокаСозданияБазы, Параметры["--spwd"]);
			КонецЕсли;
		КонецЕсли;

		Аргументы = Новый Структура();
		Аргументы.Вставить("Команда", "server");
		Аргументы.Вставить("ЗначенияПараметров", Параметры);
		runner.ОпределитьПараметрыРаботы(Аргументы);

		Конфигуратор = Новый УправлениеКонфигуратором();
		//Логирование.ПолучитьЛог("oscript.lib.v8runner").УстановитьУровень(Лог.Уровень());

		ВерсияПлатформы = Аргументы.ЗначенияПараметров["--v8version"];
		Если ЗначениеЗаполнено(ВерсияПлатформы) Тогда
			Лог.Отладка("ИнициализацироватьБазуДанных ВерсияПлатформы:"+ВерсияПлатформы);
			Конфигуратор.ИспользоватьВерсиюПлатформы(ВерсияПлатформы);
		КонецЕсли;

		ПараметрыЗапуска = Новый Массив;
		ПараметрыЗапуска.Добавить("CREATEINFOBASE");
		
		//Лог.Отладка(СтрокаСозданияБазы);
		Если НЕ ЭтоWindows Тогда
			СтрокаСозданияБазы = """"+СтрокаСозданияБазы+"""";
			СтрокаСозданияБазы = СтрЗаменить(СтрокаСозданияБазы, """", "\""");
			СтрокаСозданияБазы = СтрЗаменить(СтрокаСозданияБазы,  ";", "\;");
		КонецЕсли;
		Лог.Отладка(СтрокаСозданияБазы);

		ПараметрыЗапуска.Добавить(СтрокаСозданияБазы);
		ПараметрыЗапуска.Добавить("/L"+Параметры["--locale"]);
		ПараметрыЗапуска.Добавить("/Out""" +Конфигуратор.ФайлИнформации() + """");

		СтрокаЗапуска = "";
		СтрокаДляЛога = "";
		Для Каждого Параметр Из ПараметрыЗапуска Цикл
			СтрокаЗапуска = СтрокаЗапуска + " " + Параметр;
		КонецЦикла;

		Приложение = "";
		Приложение = Конфигуратор.ПутьКПлатформе1С();
		Если Найти(Приложение, " ") > 0 Тогда 
			Приложение = runner.ОбернутьПутьВКавычки(Приложение);
		КонецЕсли;
		СтрокаЗапуска = Приложение + " "+СтрокаЗапуска;
		Сообщить(СтрокаЗапуска);
		
		ЗаписьXML = Новый ЗаписьXML();
		ЗаписьXML.УстановитьСтроку();

		Процесс = СоздатьПроцесс(СтрокаЗапуска, "./", Истина, Истина);
		Процесс.Запустить();
		Процесс.ОжидатьЗавершения();
		ЗаписьXML.ЗаписатьБезОбработки(Процесс.ПотокВывода.Прочитать());
		РезультатРаботыПроцесса = ЗаписьXML.Закрыть();
		Сообщить(РезультатРаботыПроцесса);

		РезультатСообщение = ПрочитатьФайлИнформации(Конфигуратор.ФайлИнформации());
		Если НЕ (СтрНайти(РезультатСообщение, "успешно завершено") > 0 ИЛИ СтрНайти(РезультатСообщение, "completed successfully") > 0) Тогда
			ВызватьИсключение "Результат работы не успешен: " + Символы.ПС + РезультатСообщение; 
		КонецЕсли;

		Попытка
			УдалитьФайлы(Конфигуратор.ФайлИнформации());
		Исключение
		КонецПопытки;

		Параметры = Аргументы.ЗначенияПараметров;

КонецПроцедуры

Функция ПрочитатьФайлИнформации(Знач ПутьКФайлу)

	Текст = "";
	Файл = Новый Файл(ПутьКФайлу);
	Если Файл.Существует() Тогда
		Чтение = Новый ЧтениеТекста(Файл.ПолноеИмя);
		Текст = Чтение.Прочитать();
		Чтение.Закрыть();
	Иначе
		Текст = "Информации об ошибке нет";
	КонецЕсли;

	Лог.Отладка("файл информации:
	|"+Текст);
	Возврат Текст;

КонецФункции


Функция ЗначениеПоУмолчанию(value, defValue="")
	res = ?( ЗначениеЗаполнено(value), value, defValue);
	Возврат res;
КонецФункции

Процедура ИсполнитьКоманду(СтрокаВыполнения)

	Команда = Новый Команда;
	Команда.ПоказыватьВыводНемедленно(Истина);

	Команда.УстановитьПравильныйКодВозврата(0);

	Лог.Информация(СтрокаВыполнения);
	Команда.УстановитьСтрокуЗапуска(СтрокаВыполнения);
	Команда.Исполнить();

КонецПроцедуры

Функция Форматировать(Знач Уровень, Знач Сообщение) Экспорт

	Возврат СтрШаблон("%1: %2 - %3", ТекущаяДата(), УровниЛога.НаименованиеУровня(Уровень), Сообщение);

КонецФункции

ИнициализацияОкружения();
