import {Notification} from "./notification.component";

const template = `

<div class="row notification-inbox">
  <div class="mx-auto">
    <div id="notifications">
      <Notification 
            v-for="notification in notifications" 
            @removed="removeNotification(notification.id)"
            :key="notification.id" 
            :notification="notification"
      />
      <div class="notification-inbox__empty" v-if="notifications.length === 0">
        <p class="notification-inbox__empty-text">You don't have any notifications yet. 🕵️</p>
      </div>
    </div>
  </div>
</div>

`

Vue.createApp({
    template,
    components: {
        Notification,
    },
    data() {
        return {
            notifications: []
        }
    },
    created() {
        this.retrieveNotifications()
        setInterval(this.retrieveNotifications, 1000);
    },
    methods: {
        removeNotification(notificationId) {
            this.notifications = this.notifications.filter(notification => {
                return notification.id !== notificationId
            });
        },
        retrieveNotifications() {
            fetch(`/notifications/`, {method: 'GET', redirect: 'follow'})
                .then(result => result.json())
                .then(data => {
                    this.notifications = data;
                })
                .catch(error => console.log('error', error));
        }
    }
}).mount('#notification-centre')
