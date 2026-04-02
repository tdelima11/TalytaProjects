trigger FCAAccountChangeTrigger on Account (before update) {
    FCAAccountChangeHandler.compareAndNotify(trigger.new, trigger.oldMap);
}