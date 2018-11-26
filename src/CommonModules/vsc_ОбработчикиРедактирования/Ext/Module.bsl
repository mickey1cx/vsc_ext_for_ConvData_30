﻿#Область ОбработчикиРедактирования

Процедура РедактированиеПравил(ОбъектСсылка, Форма) Экспорт
	
	ПараметрыОбработчика = ПолучитьПараметрыОбработчика(ОбъектСсылка, Форма);
	
	Если ЗначениеЗаполнено(ПараметрыОбработчика) Тогда
		ЗапускРедактора(Форма, ПараметрыОбработчика);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Перейдите на вкладку с кодом обработчика");
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗапускРедактора(Форма, ПараметрыОбработчика)
	
	ФайлОбработчика = ФайлОбработчика(ПараметрыОбработчика);
	ДополнительныеПараметры = Новый Структура("ФайлОбработчика, Форма, РеквизитКода", ФайлОбработчика, Форма, ПараметрыОбработчика.РеквизитКода);
	ОбработчикЗакрытия = Новый ОписаниеОповещения("ЗапускРедактора_Завершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьЗапускПриложения(ОбработчикЗакрытия, ФайлОбработчика,, Истина);
	
КонецПроцедуры

Процедура ЗапускРедактора_Завершение(КодВозврата, ДополнительныеПараметры) Экспорт

	ФайлОбработчика = ДополнительныеПараметры.ФайлОбработчика;
	Если НЕ КодВозврата = Неопределено Тогда
		ОбъектФормы = ДополнительныеПараметры.Форма.Объект;
		ТекстОбработчика = СокрЛП(ПолучитьТекстОбработчика(ФайлОбработчика));
		Если НЕ СокрЛП(ОбъектФормы[ДополнительныеПараметры.РеквизитКода]) = ТекстОбработчика Тогда
			ОбъектФормы[ДополнительныеПараметры.РеквизитКода] = ТекстОбработчика;
			ДополнительныеПараметры.Форма.Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
	УдалитьФайлы(ФайлОбработчика);

КонецПроцедуры

Функция ПолучитьТекстОбработчика(ИмяФайла)
	
	ТекстФайла = Новый ТекстовыйДокумент;     
	ТекстФайла.Прочитать(ИмяФайла);
	ТекстФайла.УдалитьСтроку(1);
	ТекстФайла.УдалитьСтроку(ТекстФайла.КоличествоСтрок());
	ТекстОбработчика = ТекстФайла.ПолучитьТекст();

	Возврат ТекстОбработчика;
	
КонецФункции

Функция ФайлОбработчика(ПараметрыОбработчика)
	
	ТекстФайла = Новый ТекстовыйДокумент;     
	ТекстФайла.УстановитьТипФайла(КодировкаТекста.UTF8);
	
	ТекстФайла.ДобавитьСтроку(
		?(ПараметрыОбработчика.ЭтоФункция, "Функция ", "Процедура ") 
		+ ПараметрыОбработчика.ИмяОбработчика 
		+ "(" + ПараметрыОбработчика.Параметры + ")" 
		+ ?(ПараметрыОбработчика.Экспортный, " Экспорт", ""));
	ТекстФайла.ДобавитьСтроку(ПараметрыОбработчика.ТекстОбработчика);
	ТекстФайла.ДобавитьСтроку(?(ПараметрыОбработчика.ЭтоФункция, "КонецФункции", "КонецПроцедуры"));
	
	ИмяФайла = ПолучитьИмяВременногоФайла("bsl");
	ТекстФайла.Записать(ИмяФайла);
	
	Возврат ИмяФайла;
	
КонецФункции

#КонецОбласти

#Область ПараметрыОбработчиков

Функция ПолучитьПараметрыОбработчика(ОбъектСсылка, Форма)
	
	Перем ПараметрыОбработчика;
	Перем ДополнительныеСведения;
	
	ОбъектФормы = Форма.Объект;
	ТипПараметра = ТипЗнч(ОбъектСсылка);
	
	Если ТипПараметра = Тип("СправочникСсылка.Алгоритмы") Тогда
		ПараметрыОбработчика = ПараметрыОбработчика_Алгоритмы(ОбъектФормы);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.Конвертации") 
		И ДополнительныеСведения_Конвертации(Форма, ДополнительныеСведения) Тогда
 		ПараметрыОбработчика = ПараметрыОбработчика_Конвертации(ОбъектФормы, ДополнительныеСведения);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ПравилаКонвертацииОбъектов") 
		И ДополнительныеСведения_ПравилаКонвертацииОбъектов(Форма, ДополнительныеСведения) Тогда
		ПараметрыОбработчика = ПараметрыОбработчика_ПравилаКонвертацииОбъектов(ОбъектФормы, ДополнительныеСведения);
	ИначеЕсли ТипПараметра = Тип("СправочникСсылка.ПравилаОбработкиДанных") 
		И ДополнительныеСведения_ПравилаОбработкиДанных(Форма, ДополнительныеСведения) Тогда
		ПараметрыОбработчика = ПараметрыОбработчика_ПравилаОбработкиДанных(ОбъектФормы, ДополнительныеСведения);
	КонецЕсли;
	
	Возврат ПараметрыОбработчика;
	
КонецФункции

Функция ПараметрыОбработчика_Алгоритмы(ОбъектФормы)
	
	Возврат ПараметрыОбработчика("Алгоритм", 
			ОбъектФормы.Алгоритм, 
			СокрЛП(ОбъектФормы.Код), 
			ОбъектФормы.ЭтоФункция, 
			ОбъектФормы.Параметры, 
			ОбъектФормы.Экспортный);
	
КонецФункции

Функция ПараметрыОбработчика_Конвертации(ОбъектФормы, ДополнительныеСведения)
	
	Возврат ПараметрыОбработчика(ДополнительныеСведения.РеквизитКода, 
			ОбъектФормы[ДополнительныеСведения.РеквизитКода],
			ДополнительныеСведения.ИмяОбработчика,
			Ложь,
			"КомпонентыОбмена",
			Истина);
	
КонецФункции

Функция ПараметрыОбработчика_ПравилаКонвертацииОбъектов(ОбъектФормы, ДополнительныеСведения)
	
	Возврат ПараметрыОбработчика(ДополнительныеСведения.РеквизитКода, 
			ОбъектФормы[ДополнительныеСведения.РеквизитКода],
			ДополнительныеСведения.ИмяОбработчика,
			Ложь,
			ДополнительныеСведения.Параметры,
			Ложь);
	
КонецФункции

Функция ПараметрыОбработчика_ПравилаОбработкиДанных(ОбъектФормы, ДополнительныеСведения)
	
	Возврат ПараметрыОбработчика(ДополнительныеСведения.РеквизитКода, 
			ОбъектФормы[ДополнительныеСведения.РеквизитКода],
			ДополнительныеСведения.ИмяОбработчика,
			Ложь,
			ДополнительныеСведения.Параметры,
			Ложь);
	
КонецФункции

#КонецОбласти

#Область ДополнительныеСведения

Функция ДополнительныеСведения_Конвертации(Форма, ДополнительныеСведения)
	
	Элементы = Форма.Элементы;
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.ПередКонвертацией Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПередКонвертацией", Форма.ИмяОбработчикаПередКонвертацией);
	ИначеЕсли ТекущаяСтраница = Элементы.ПередОтложеннымЗаполнением Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПередОтложеннымЗаполнением", Форма.ИмяОбработчикаПередОтложеннымЗаполнением);
	ИначеЕсли ТекущаяСтраница = Элементы.ПослеКонвертации Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПослеКонвертации", Форма.ИмяОбработчикаПослеКонвертации);
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	ДополнительныеСведения.Параметры = "КомпонентыОбмена";
	
	Возврат Истина;
	
КонецФункции

Функция ДополнительныеСведения_ПравилаКонвертацииОбъектов(Форма, ДополнительныеСведения)
	
	Элементы = Форма.Элементы;
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.Страница_ПриОтправке Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПриОтправкеДанных", Форма.ИмяОбработчикаПриОтправке, 
		"ДанныеИБ, ДанныеXDTO, КомпонентыОбмена, СтекВыгрузки");
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПриКонвертацииДанныхXDTO Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПередПолучениемДанных", Форма.ИмяОбработчикаПередПолучением,
		"ДанныеXDTO, ПолученныеДанные, КомпонентыОбмена");
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ПередЗаписьюПолученныхДанных Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПриПолученииДанных", Форма.ИмяОбработчикаПриПолучении,
		"ПолученныеДанные, ДанныеИБ, КонвертацияСвойств, КомпонентыОбмена");
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ДополнительныеСведения_ПравилаОбработкиДанных(Форма, ДополнительныеСведения)
	
	Элементы = Форма.Элементы;
	ТекущаяСтраница = Элементы.Страницы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.Страница_ПриОбработке Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмПриОбработке", Форма.ИмяОбработчикаПриОбработке, 
		"ДанныеИБ, ИспользованиеПКО, КомпонентыОбмена");
	ИначеЕсли ТекущаяСтраница = Элементы.Страница_ВыборкаДанных Тогда
		ДополнительныеСведения = ДополнительныеСведения("АлгоритмВыборкаДанных", Форма.ИмяОбработчикаВыборкаДанных,
		"КомпонентыОбмена");
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти

#Область ПрочиеФункции

Функция ДополнительныеСведения(РеквизитКода = Неопределено, ИмяОбработчика = Неопределено, Параметры = Неопределено, ЭтоФункция = Неопределено, Экспортный = Неопределено)
	
	Возврат Новый Структура("РеквизитКода, ИмяОбработчика, Параметры, ЭтоФункция, Экспортный", 
	РеквизитКода, ИмяОбработчика, Параметры, ЭтоФункция, Экспортный);
	
КонецФункции

Функция ПараметрыОбработчика(РеквизитКода = Неопределено, 
							ТекстОбработчика = Неопределено, 
							ИмяОбработчика = Неопределено, 
							ЭтоФункция = Неопределено, 
							Параметры = Неопределено, 
							Экспортный = Неопределено)
	
	Возврат Новый Структура("РеквизитКода, ТекстОбработчика, ИмяОбработчика, ЭтоФункция, Параметры, Экспортный",
	РеквизитКода, ТекстОбработчика, ИмяОбработчика, ЭтоФункция, Параметры, Экспортный);
	
КонецФункции	

#КонецОбласти