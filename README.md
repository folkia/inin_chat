# InteractionWebTools

This project implements rails engine to add chat functionality provided by InteractionWebTools

# Supported calls

## POST /chat/start

+ Request (application/json)

        {
            "supportedContentTypes": "text/plain",
            "participant": {
                "name": "Customer",
                "credentials": ""
            },
            "transcriptRequired": false,
            "emailAddress": "",
            "target": "Chatgroup",
            "targetType": "Workgroup",
            "customInfo": "Frogtail Chat test annotation!|phone=",
            "language": "sv",
            "clientToken": "deprecated"
        }

+ Response 200 (application/json; charset=utf-8)

    + Body

            {
            	"chat": {
            		"pollWaitSuggestion": 2000,
            		"cfgVer": 1,
            		"participantID": "c838a445-a97f-4590-8b70-fff844ed5595",
            		"dateFormat": "yyyy-MM-dd",
            		"timeFormat": "HH:mm:ss",
            		"chatID": "df6abb0d-5216-47be-be28-e803c68fc38d",
            		"status": {
            			"type": "success"
            		}
            	}
            }

## GET /websvcs/chat/poll/{participantID}

+ Response 200 (application/json; charset=utf-8)

    + Body

            {
            	"chat": {
            		"pollWaitSuggestion": 2000,
            		"cfgVer": 1,
            		"events": [],
            		"status": {
            			"type": "success"
            		}
            	}
            }

## POST /websvcs/chat/sendMessage/{participantID}
+ Request (application/json)

        {
            "message": "Test message from customer 2016-03-22T09:12:36+0000",
            "contentType": "text/plain"
        }

+ Response 200 (application/json; charset=utf-8)

    + Body

            {
            	"chat": {
            		"pollWaitSuggestion": 2000,
            		"cfgVer": 1,
            		"status": {
            			"type": "success"
            		},
            		"events": [{
            			"type": "text",
            			"participantID": "b6c0849e-f0d6-4516-9970-3ce44a951cde",
            			"sequenceNumber": 29,
            			"conversationSequenceNumber": 0,
            			"contentType": "text\/plain",
            			"value": "Test message from customer 2016-01-22T09:35:12+0000",
            			"displayName": "Customer",
            			"participantType": "WebUser"
            		}]
            	}
            }

## POST /chat/exit/{participantID}
+ Response 200 (application/json; charset=utf-8)

    + Body

            {
            	"chat": {
            		"pollWaitSuggestion": 2000,
            		"cfgVer": 1,
            		"status": {
            			"type": "success"
            		},
            		"events": []
            	}
            }
            
# Supported event types

All events should be processed without error, but not all of them affect chat

## participantStateChanged
This event in participantType 'WebUser' case terminates chat from server side

		{
			"type": "participantStateChanged",
			"participantID": "bd705761-6cf2-4634-8851-cf6571006d38",
			"sequenceNumber": 22,
			"state": "active",
			"participantName": "Jo",
			"participantType": "Agent"
		}
## text
text message event

		{
			"type": "text",
			"participantID": "cda5ac86-046a-461f-9ed9-881f4cba233c",
			"sequenceNumber": 13,
			"conversationSequenceNumber": 0,
			"contentType": "text\/plain",
			"value": "I do record logs",
			"displayName": "test",
			"participantType": "WebUser"
		}
	

This project rocks and uses MIT-LICENSE.
