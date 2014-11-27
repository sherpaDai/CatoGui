
// copy this code to the `object` in your 
// app/models/${classname}.scala file
// ======================================

/**
 * JSON Serializer Code
 * --------------------
 */
import play.api.libs.json.Json
import play.api.libs.json._
import java.text.SimpleDateFormat

implicit object ${classname}Format extends Format[${classname}] {

    // convert from ${classname} object to JSON (serializing to JSON)
    def writes(${objectname}: ${classname}): JsValue = {
        val sdf = new SimpleDateFormat("yyyy-MM-dd")
        val ${objectname}Seq = Seq(
        // VERIFY valid types are JsString, JsNumber, JsBoolean, JsArray, JsNull, JsObject
        // DATE example: "datetime" -> JsString(sdf.format(researchLink.datetime)),
        // SEE http://www.playframework.com/documentation/2.2.x/ScalaJson
<#list fields as field>
<#if field.isRequired() >
           "${field.camelCaseFieldName}" -> ${field.jsonFieldType}(${objectname}.${field.fieldName})<#if   field_has_next>,</#if>
<#else>
           "${field.camelCaseFieldName}" ->   ${field.jsonFieldType}(${objectname}.${field.fieldName}.getOrElse(""))<#if field_has_next>,</#if>
</#if>
</#list>
        )
        JsObject(${objectname}Seq)
    }

    // convert from a JSON string to a <<$classname>> object (de-serializing from JSON)
    // TODO the CSV string inside the JsSuccess() is wrong; this is a known problem. copy/paste
    // the correct variable names inside the JsSuccess() method.
    // @see http://www.playframework.com/documentation/2.2.x/ScalaJson regarding Option
    // DATE fields should be like: val datetime = (json \ "datetime").as[java.util.Date]
    def reads(json: JsValue): JsResult[${classname}] = {
<#list fields as field>
<#if field.isRequired() >
        val "${field.camelCaseFieldName}" -> (json \ "${field.camelCaseFieldName}").as[${field.scalaFieldType}] 
<#else>
        val "${field.camelCaseFieldName}" -> (json \   "${field.camelCaseFieldName}").asOpt[${field.scalaFieldType}] 
</#if>
</#list>
        JsSuccess(${classname}(${fieldsAsInsertCsvString}))
    }
}
