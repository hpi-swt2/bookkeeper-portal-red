const template = `

<div class="card notification-message">
  <div class="card-body">
    <p class="card-title">
      <strong>{{ type }}</strong> - {{ date }}, {{ time }}
      <div class="pr-4">
        <button @click="remove" class="text-right position-absolute top-0 end-0 text-primary fs-4 btn btn-icon" id="delete-notification-button-id">
          <i class="bi bi-x"></i>
        </button>
      </div>
    </p>
    <p>{{ message }}</p>
    <a class="card-link" @click="collapsed = !collapsed" v-if="expandable">
        {{ collapsed ? "Show more" : "Show less" }}
    </p>
  </div>
</div>

`

const MSG_CUTOFF = 100;

export const Notification = {
    template,
    props: {
        notification: {
            id: Number,
            type: String,
            message: String,
            sent: String
        }
    },
    data: () => {
        return {
            collapsed: true
        }
    },
    methods: {
        remove() {
            fetch(`/notifications/${this.id}`, {method: 'DELETE', redirect: 'follow'})
                .then(result => {
                    if (result.status >= 200 && result.status < 300) {
                        this.$emit("removed");
                    } else {
                        throw new Error(`Failed to delete Notification with id ${this.id}`);
                    }
                })
                .catch(error => console.log('error', error));
        }
    },
    computed: {
        id() {
            return this.notification.id
        },
        date() {
            let date = new Date(this.notification.sent);
            return `${date.getDay()}.${date.getMonth()}.${date.getFullYear()}`;
        },
        time() {
            let date = new Date(this.notification.sent);
            return `${date.getHours()}:${date.getMinutes()}`;
        },
        message() {
            if (this.collapsed) {
                return this.shortMessage + (this.expandable ? "..." : "");
            }
            return this.longMessage;
        },
        shortMessage() {
            return this.notification.message.slice(0, MSG_CUTOFF);
        },
        longMessage() {
            return this.notification.message;
        },
        expandable() {
            return this.shortMessage !== this.longMessage;
        },
        type() {
            return "Reminder";
        }
    }
}