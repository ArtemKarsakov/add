﻿Перем Ожидаем;
Перем ИтераторМетаданных;

#Область Стандартный_интерфейс

Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	
	// Подключаем плагин для текучих утверждений
	Ожидаем = КонтекстЯдраПараметр.Плагин("УтвержденияBDD");
	
	// Подключаем Итератор
	ИтераторМетаданных = КонтекстЯдраПараметр.Плагин("ИтераторМетаданных");
	ИтераторМетаданных.Инициализация(КонтекстЯдраПараметр); // Сбрасываем настройки Итератора
	ИтераторМетаданных.ДополнятьЗависимымиОбъектами = Истина;
	// Исключим коллекции, у элементов которых нет свойства РежимУправленияБлокировкойДанных
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.Перечисления);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.Обработки);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.Отчеты);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.ЖурналыДокументов);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.НумераторыДокументов);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.КритерииОтбора);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.HTTPСервисы);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.ОбщиеРеквизиты);
	ИтераторМетаданных.ИсключаемыеМетаданные.Добавить(Метаданные.WSСсылки);
	
	ЗагрузитьНастройки(КонтекстЯдраПараметр);
	
КонецПроцедуры

Процедура ЗаполнитьНаборТестов(НаборТестовПараметр, КонтекстЯдраПараметр) Экспорт
	
	Если Метаданные.РежимУправленияБлокировкойДанных = Метаданные.СвойстваОбъектов.РежимУправленияБлокировкойДанныхПоУмолчанию.Управляемый Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем плагины
	Инициализация(КонтекстЯдраПараметр);
	
	// Из итератора получаем ДеревоЗначений с описанием метаданных
	ДеревоМетаданных = ИтераторМетаданных.ДеревоМетаданных();
	
	// Проходим по дереву, по корневым узлам
	Для Каждого КорневаяСтрока Из ДеревоМетаданных.Строки Цикл
		
		Родитель = КорневаяСтрока.ОбъектМетаданных;
		// Начинаем группу тестов по разделу метаданных
		ИмяНабораТестов = "Проверка режима блокировки данных " + Родитель;
		НаборТестовПараметр.НачатьГруппу(ИмяНабораТестов);
		
		// Проходим по составу раздела метаданных
		Для Каждого СтрокаМетаданных Из КорневаяСтрока.Строки Цикл
			
			ТекОбъектМетаданных = СтрокаМетаданных.ОбъектМетаданных;
			ПолноеИмяОбъекта = ТекОбъектМетаданных.ПолноеИмя();
			ЭтоВебСервис = Найти(ПолноеИмяОбъекта, "WebСервис")=1;
			Если Настройки.Найти(ПолноеИмяОбъекта) <> Неопределено Тогда
				Сообщение = "Объект" + ПолноеИмяОбъекта +" исключен из проверки";
				ЗаписьЖурналаРегистрации("SmokeLockMode",УровеньЖурналаРегистрации.Информация,,,Сообщение);
				КонтекстЯдра.ВывестиСообщение(Сообщение);
				Продолжить;
			КонецЕсли;
			Если ЭтоВебСервис Тогда
				// Для веб-сервиса режим блокировки проверяем у его операций
				Для Каждого Операция Из ТекОбъектМетаданных.Операции Цикл
					ПараметрыТеста = НаборТестовПараметр.ПараметрыТеста(ПолноеИмяОбъекта, Родитель, Операция.Имя);
					ЗаголовокТеста = "" + ПолноеИмяОбъекта + "." + Операция.Имя + " - " + ИмяНабораТестов;
					НаборТестовПараметр.Добавить("Тест_ПроверитьРежимБлокировкиОбъекта", ПараметрыТеста, ЗаголовокТеста);
				КонецЦикла;
			Иначе
				ПараметрыТеста = НаборТестовПараметр.ПараметрыТеста(ПолноеИмяОбъекта, Родитель, "");
				ЗаголовокТеста = ПолноеИмяОбъекта + " - " + ИмяНабораТестов;
				НаборТестовПараметр.Добавить("Тест_ПроверитьРежимБлокировкиОбъекта", ПараметрыТеста, ЗаголовокТеста);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Сам тест
Процедура Тест_ПроверитьРежимБлокировкиОбъекта(ПолноеИмяМетаданного, Родитель, ИмяОперации) Экспорт
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМетаданного);
	Если ЗначениеЗаполнено(ИмяОперации) Тогда
		ОбъектМетаданных = ОбъектМетаданных.Операции.Найти(ИмяОперации);
	КонецЕсли;
	РежимПроверен = ОбъектМетаданных.РежимУправленияБлокировкойДанных = Метаданные.РежимУправленияБлокировкойДанных;
	ТекстОшибки = "Режим блокировки объекта метаданных не соответствует корневому режиму конфигурации!";
	Ожидаем.Что(РежимПроверен, ТекстОшибки).ЕстьИстина();
	
КонецПроцедуры

#КонецОбласти

#Область РаботаСнастройками

Процедура ЗагрузитьНастройки(КонтекстЯдраПараметр)
	
	ПутьНастройки = "SmokeLockMode";
	ПлагинНастроек = КонтекстЯдраПараметр.Плагин("Настройки");
	ПлагинНастроек.Инициализация(КонтекстЯдраПараметр);
	Настройки = ПлагинНастроек.ПолучитьНастройку(ПутьНастройки);
	Если Не ЗначениеЗаполнено(Настройки) Тогда
		Настройки = Новый Массив;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
