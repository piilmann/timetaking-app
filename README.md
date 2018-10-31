# Timetaking App made with Flutter


<div style="text-align: center"><table><tr>
  <td style="text-align: center">
  <img src="https://i.imgur.com/wwKohN0.png" width="200" height="430" />
</td>
<td style="text-align: center">
  <img src="https://i.imgur.com/iAGGxVx.png" width="200" height="430" />
  </a>
</td>
</tr></table></div>
(Screenshots taking on a iOS Simulator)

This app is made to make it easier to take time of runners in a running competetion, without using time taking chips.

The app makes simple REST calls to the specific URL endpoint specified in the settings page. It is the backend's responsibilty to take the time, when the request is received. 

### Request format
`{"id":"runner id"}` - Both key and value, is a sent as strings.


#### Examples

`{"id":"25"}` - Sent from the "Enter ID" page, when the number 25, is entered and the green checkmark is clicked

`{"id":"9999991"}` - Request sent when clicking the start time button for the first starting time 

`{"id":"9999992"}` - Request sent when clicking the start time button for the second starting time 

`{"id":"9999993"}` - Request sent when clicking the start time button for the third starting time 
