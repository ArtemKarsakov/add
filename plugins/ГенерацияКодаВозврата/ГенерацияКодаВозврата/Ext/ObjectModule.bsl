﻿
// { Plugin interface
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Результат = Новый Структура;
	Результат.Вставить("Тип", ВозможныеТипыПлагинов.Утилита);
	Результат.Вставить("Идентификатор", Метаданные().Имя);
	Результат.Вставить("Представление", "Генерация файла кода возврата");
	
	Возврат Новый ФиксированнаяСтруктура(Результат);
КонецФункции

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры
// } Plugin interface

Процедура СформироватьФайл(КонтекстЯдра, Знач ПутьФайлаКодаВозврата, Знач РезультатыТестирования) Экспорт
	ЭтотОбъект.СостоянияТестов = КонтекстЯдра.СостоянияТестов;
	
	СформироватьФайлКодаВозврата(КонтекстЯдра, ПутьФайлаКодаВозврата, РезультатыТестирования);
КонецПроцедуры

Процедура СформироватьФайлКодаВозврата(КонтекстЯдра, Знач ПутьФайлаКодаВозврата, Знач РезультатыТестирования)
	Попытка
		КодВозврата = 0;
		Если Не ЗначениеЗаполнено(РезультатыТестирования) 
				ИЛИ РезультатыТестирования.Состояние = СостоянияТестов.Сломан 
				или РезультатыТестирования.Состояние = СостоянияТестов.НеизвестнаяОшибка Тогда

			КодВозврата = 1;

		ИначеЕсли РезультатыТестирования.Состояние = СостоянияТестов.НеРеализован Тогда

			КодВозврата = 2;

		КонецЕсли;
		
		Сообщение = "КодВозврата " + КодВозврата;
		ЗафиксироватьВЖурналеРегистрации("xUnitFor1C", Сообщение);

		ЗаписьJSON = Новый ЗаписьJSON;
		ЗаписьJSON.ОткрытьФайл(ПутьФайлаКодаВозврата);
		ЗаписьJSON.ЗаписатьЗначение(КодВозврата);
		ЗаписьJSON.Закрыть();
	Исключение
		Инфо = ИнформацияОбОшибке();
		ОписаниеОшибки = "Ошибка формирования файла статуса возврата при выполнении тестов в пакетном режиме
		|" + ПодробноеПредставлениеОшибки(Инфо);
		
		ЗафиксироватьОшибкуВЖурналеРегистрации("xUnitFor1C", ОписаниеОшибки);
		Сообщить(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
	КонецПопытки;
КонецПроцедуры

Процедура ЗафиксироватьВЖурналеРегистрации(Знач ИдентификаторГенератораОтчета, Знач Описание)
	ЗаписьЖурналаРегистрации(ИдентификаторГенератораОтчета, УровеньЖурналаРегистрации.Информация, , , Описание);
КонецПроцедуры

Процедура ЗафиксироватьОшибкуВЖурналеРегистрации(Знач ИдентификаторГенератораОтчета, Знач ОписаниеОшибки) Экспорт
	ЗаписьЖурналаРегистрации(ИдентификаторГенератораОтчета, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
КонецПроцедуры
