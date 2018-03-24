function astSpeak([string]$inputString, [int]$speed = -2, 
         [int]$engine = 0, [switch]$file,
         [switch]$list, [switch]$buffer,
         [int]$volume = 85)
{
  # Создаем объект
  $oVoice = New-Object -com "SAPI.spvoice"
    Write-Output "Установленные в системе голоса: "
  # Если требуется вывести список голосов
  if($list)
  {
    Write-Output "Установленные в системе голоса: "
    $i = 0
    Foreach ($Token in $oVoice.getvoices())
    {
      Write-Host $i - $Token.getdescription()
      $i++
    }    
  }
  # Если требуется проговорить
  else
  {
    # Получаем текст из файла, если задан переключатель
    if($file){ $toSpeechText = Get-Content $inputString}
    # Проговариваем текст из буфера обмена (требует режима sta)
    elseif($buffer){
     $null = [reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
     $toSpeechText = [Windows.Forms.Clipboard]::GetText() }
    # Используем полученную строку, если переключатель не задан
    else{ $toSpeechText = $inputString}
    
    # Воспроизводим
    $oVoice.rate = $speed
    $oVoice.volume = $volume
    $oVoice.voice = $oVoice.getvoices().item($engine)    
    $oVoice.Speak($toSpeechText)
  }
}