<template>
  <ion-page>
    <ion-header>
      <ion-toolbar>
        <ion-title>Capacitor Test Plugin Project</ion-title>
      </ion-toolbar>
    </ion-header>
    <ion-content class="ion-padding">
      <h1>Capacitor Test Plugin Project</h1>
      <p>
        This project can be used to test out the functionality of your plugin. Nothing in the <em>example/</em>
        folder
        will be published to npm when using this template, so you can create away!
      </p>
      <!-- <ion-button @click="getBrotherPrinters()">Find Network Printers</ion-button> -->

      <div v-if="printerList.length > 0">
        <ion-list>
          <ion-item v-for="(printer, index) in printerList" :key="index">
            <ion-label>{{ printer.modelName }}</ion-label>
            <ion-button @click="selectPrinter(printer)">Select</ion-button>
          </ion-item>
        </ion-list>
      </div>
      <div v-if="selectedPrinter">
        <div v-if="selectedPrinter">
          <h3>Selected Printer Details:</h3>
          <p><strong>Model Name:</strong> {{ selectedPrinter.modelName }}</p>
          <p><strong>IP Address:</strong> {{ selectedPrinter.ipAddress }}</p>
        </div>
        <ion-button @click="getPrinterStatus(selectedPrinter)">Get Printer Status</ion-button>
        <ion-button @click="printLabel(selectedPrinter)">Print Label</ion-button>

        <div v-if="selectedPrinterStatus">
          <h3>Printer Status:</h3>
          <pre><code>{{ JSON.stringify(selectedPrinterStatus, null, 2) }}</code></pre>
        </div>
      </div>

    </ion-content>
  </ion-page>
</template>

<script setup>
import { IonPage, IonHeader, IonToolbar, IonTitle, IonContent, IonButton, IonList, IonItem, IonLabel } from '@ionic/vue';
import { CapacitorPluginLabelPrinter } from 'capacitor-plugin-label-printer';
import { onMounted, ref } from 'vue';


const printerList = ref([]);
const selectedPrinter = ref(null);
const selectedPrinterStatus = ref(null);


onMounted(async () => {
  await getBrotherPrinters();
});

const selectPrinter = async (printer) => {
  // Implement selectPrinter logic here
  selectedPrinter.value = printer;
  console.log('Select Printer clicked');
};

const getBrotherPrinters = async () => {
  try {
    const result = await CapacitorPluginLabelPrinter.getBrotherPrinters();
    printerList.value = result.printers;
    console.log('Brother Printers:', result.printers);
  } catch (error) {
    console.error('Error getting Brother printers:', error);
  }
};

const getPrinterStatus = async (printer) => {
  try {
    const result = await CapacitorPluginLabelPrinter.getPrinterStatus({
      ipAddress: printer.ipAddress
    });
    selectedPrinterStatus.value = result.status;
    console.log('Printer Status:', result.status);
  } catch (error) {
    console.error('Error getting printer status:', error);
  }
};

const printLabel = async (printer) => {
  console.log('Print Label clicked');
  try {
    await CapacitorPluginLabelPrinter.printLabel({
      ipAddress: printer.ipAddress,
      imageUrl: 'https://delivery.churchlabcdn.com/test-label.png'
    });
    console.log('Label printed successfully');
  } catch (error) {
    console.error('Error printing label:', error);
  }
};

</script>

<style scoped>
pre {
  background-color: #f4f4f4;
  border: 1px solid #ddd;
  border-radius: 4px;
  padding: 10px;
  white-space: pre-wrap;
  word-wrap: break-word;
}

code {
  font-family: monospace;
}
</style>
